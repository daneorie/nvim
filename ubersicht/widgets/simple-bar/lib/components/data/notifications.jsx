import * as Uebersicht from "uebersicht";
import * as DataWidget from "./data-widget.jsx";
import * as DataWidgetLoader from "./data-widget-loader.jsx";
import * as Icons from "../icons.jsx";
import useWidgetRefresh from "../../hooks/use-widget-refresh";
import * as Settings from "../../settings";
import * as Utils from "../../utils";
import * as AppIdentifiers from "../../app-identifiers";
import * as AppOptions from "../../app-options";

export { notificationsStyle as styles } from "../../styles/components/data/notifications.js";

const settings = Settings.get();
const { widgets, notificationWidgetOptions } = settings;
const { notificationWidget } = widgets;
const { refreshFrequency } = notificationWidgetOptions;

const DEFAULT_REFRESH_FREQUENCY = 1000;
const REFRESH_FREQUENCY = Settings.getRefreshFrequency(
  refreshFrequency,
  DEFAULT_REFRESH_FREQUENCY
);

const openMessages = () =>
  Uebersicht.run(
    `open -a Messages`
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
    }));

    setLoading(false);
  };

  useWidgetRefresh(notificationWidget, getNotifications, REFRESH_FREQUENCY);

  if (loading) return <DataWidgetLoader.Widget className="notification" />;
  if (!state) return null;

  const onClick = (e) => {
    Utils.clickEffect(e);
    openMessages();
  };

	console.log({state});

	return (
		<DataWidget.Widget
			classes="notifications"
			onClick={onClick}
		>
			{Object.keys(state)
				.filter(appName => state[appName] > 0 && notificationWidgetOptions[AppOptions.apps[appName]])
				.map((appName, _) => {
					const Icon = Icons[appName] || Icons[Default];
					return <div>
						<Icon className="notification" />
						{state[appName]}
					</div>
				})
			}
		</DataWidget.Widget>
  )

}
