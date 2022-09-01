import * as Uebersicht from "uebersicht";
import * as DataWidget from "./data-widget.jsx";
import * as DataWidgetLoader from "./data-widget-loader.jsx";
import * as AppIcons from "../../app-icons";
import * as AppIdentifiers from "../../app-identifiers";
import * as Settings from "../../settings";
import useWidgetRefresh from "../../hooks/use-widget-refresh";

export { notificationsStyles as styles } from "../../styles/components/data/notifications.js";

const settings = Settings.get();
const { widgets, notificationWidgetOptions } = settings;
const { notificationWidget } = widgets;
const { refreshFrequency } = notificationWidgetOptions;

const DEFAULT_REFRESH_FREQUENCY = 20000;
const REFRESH_FREQUENCY = Settings.getRefreshFrequency(
  refreshFrequency,
  DEFAULT_REFRESH_FREQUENCY
);

export const Widget = () => {
  const [state, setState] = Uebersicht.React.useState({});
  const [loading, setLoading] = Uebersicht.React.useState(notificationWidget);

  const getNotifications = async () => {
    const database = await Uebersicht.run(
      `lsof -p $(ps aux | grep -m1 usernoted | awk '{ print $2 }') | awk '{ print $NF }' | grep 'db2/db$'`
    );

    await Promise.all(Object.keys(AppIdentifiers.apps).map(async appName => {
      const appBadge = await Uebersicht.run(
        `echo "SELECT badge FROM app WHERE identifier = '${AppIdentifiers.apps[appName]}';" | sqlite3 ${database}`
      );
		
      setState(state => ({...state, [appName]: Number(appBadge) }));
    }))

    setLoading(false);
  };

  useWidgetRefresh(notificationWidget, getNotifications, REFRESH_FREQUENCY);

  if (loading) return <DataWidgetLoader.Widget className="notification" />;
  if (!state) return null;

  return (
    <div>
      {Object.keys(state)
        .filter(appName => state[appName] > 0)
        .map((appName, _) =>
          <DataWidget.Widget classes="keyboard" Icon={AppIcons.apps[appName] || AppIcons.apps["Default"]}>
            {state[appName]}
          </DataWidget.Widget>
        )
      }
    </div>
  )

}
