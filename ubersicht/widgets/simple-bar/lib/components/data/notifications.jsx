import * as Uebersicht from "uebersicht";
import * as DataWidget from "./data-widget.jsx";
import * as DataWidgetLoader from "./data-widget-loader.jsx";
import * as Icons from "../icons.jsx";
import useWidgetRefresh from "../../hooks/use-widget-refresh";
import * as Settings from "../../settings";
import * as Utils from "../../utils";
import * as AppIdentifiers from "../../app-identifiers";
import * as AppOptions from "../../app-options";
import * as AppNotifications from "../../app-notifications";

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

const openApp = (bundleIdentifier) =>
	Uebersicht.run(
		`open -b ${bundleIdentifier}`
	);

export const Widget = () => {
	const [state, setState] = Uebersicht.React.useState({});
	const [loading, setLoading] = Uebersicht.React.useState(notificationWidget);

	const getNotifications = async () => {
		notificationWidgetOptions
		await Promise.all(Object.keys(AppIdentifiers.apps)
			.filter(appName => notificationWidgetOptions[AppOptions.apps[appName]])
			.map(async appName => {
				const appBadge = await Uebersicht.run(
					`${AppNotifications.apps[appName]}`
				);

				setState(state => ({...state, [appName]: appBadge }));
			})
		);

		setLoading(false);
	};

	useWidgetRefresh(notificationWidget, getNotifications, REFRESH_FREQUENCY);

	if (loading) return <DataWidgetLoader.Widget className="notification" />;
	if (!state) return null;

	const onClick = (bundleIdentifier) => (e) => {
		Utils.clickEffect(e);
		openApp(bundleIdentifier);
	};

	return (
		<DataWidget.Widget classes="notifications">
			{Object.keys(state)
				.filter(appName => state[appName] != 0 && notificationWidgetOptions[AppOptions.apps[appName]])
				.map((appName, _) => {
					const Icon = Icons[appName] || Icons[Default];
					return <div onClick={onClick(AppIdentifiers.apps[appName])} className="notification">
						<Icon />
						{state[appName]}
					</div>
				})
			}
		</DataWidget.Widget>
	)

}
