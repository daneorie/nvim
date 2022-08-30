import * as Uebersicht from "uebersicht";
import * as DataWidget from "./data-widget.jsx";
import * as DataWidgetLoader from "./data-widget-loader.jsx";
import * as Icons from "../icons.jsx";
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
  const [state, setState] = Uebersicht.React.useState();
  const [loading, setLoading] = Uebersicht.React.useState(notificationWidget);

  const getNotifications = async () => {
    const database = await Uebersicht.run(
      `lsof -p $(ps aux | grep -m1 usernoted | awk '{ print $2 }') | awk '{ print $NF }' | grep 'db2/db$'`
    );

    const [discord, mail, messages, microsoftOutlook, microsoftTeams, reminders] = await Promise.all([
      Uebersicht.run(
        `echo "SELECT badge FROM app WHERE identifier = '${AppIdentifiers.apps["Discord"]}';" | sqlite3 ${database}`
      ),
      Uebersicht.run(
        `echo "SELECT badge FROM app WHERE identifier = '${AppIdentifiers.apps["Mail"]}';" | sqlite3 ${database}`
      ),
      Uebersicht.run(
        `echo "SELECT badge FROM app WHERE identifier = '${AppIdentifiers.apps["Messages"]}';" | sqlite3 ${database}`
      ),
      Uebersicht.run(
        `echo "SELECT badge FROM app WHERE identifier = '${AppIdentifiers.apps["Microsoft Outlook"]}';" | sqlite3 ${database}`
      ),
      Uebersicht.run(
        `echo "SELECT badge FROM app WHERE identifier = '${AppIdentifiers.apps["Microsoft Teams"]}';" | sqlite3 ${database}`
      ),
      Uebersicht.run(
        `echo "SELECT badge FROM app WHERE identifier = '${AppIdentifiers.apps["Reminders"]}';" | sqlite3 ${database}`
      ),
    ]);

    setState({
      discord: discord,
      mail: mail,
      messages: messages,
      microsoftOutlook: microsoftOutlook,
      microsoftTeams: microsoftTeams,
      reminders: reminders,
    });

    setLoading(false);
  };

  useWidgetRefresh(notificationWidget, getNotifications, REFRESH_FREQUENCY);

  if (loading) return <DataWidgetLoader.Widget className="notification" />;
  if (!state) return (
    <div>state</div>
  );
  const { discord, mail, messages, microsoftOutlook, microsoftTeams, reminders } = state;

  return (
    <div>
      {discord > 0 &&
        <DataWidget.Widget classes="keyboard" Icon={AppIcons.apps["Discord"] || AppIcons.apps["Default"]}>
          {discord}
        </DataWidget.Widget>
      }
      {mail > 0 &&
        <DataWidget.Widget classes="keyboard" Icon={AppIcons.apps["Mail"] || AppIcons.apps["Default"]}>
          {mail}
        </DataWidget.Widget>
      }
      {messages > 0 &&
        <DataWidget.Widget classes="keyboard" Icon={AppIcons.apps["Messages"] || AppIcons.apps["Default"]}>
          {messages}
        </DataWidget.Widget>
      }
      {microsoftOutlook > 0 &&
        <DataWidget.Widget classes="keyboard" Icon={AppIcons.apps["Microsoft Outlook"] || AppIcons.apps["Default"]}>
          {microsoftOutlook}
        </DataWidget.Widget>
      }
      {microsoftTeams > 0 &&
        <DataWidget.Widget classes="keyboard" Icon={AppIcons.apps["Microsoft Teams"] || AppIcons.apps["Default"]}>
          {microsoftTeams}
        </DataWidget.Widget>
      }
    </div>
  )

	  //{reminders > 0 &&
		//<DataWidget.Widget classes="keyboard" Icon={AppIcons.apps["Reminders"] || AppIcons.apps["Default"]}>
		  //{reminders}
		//</DataWidget.Widget>
	  //}
}
