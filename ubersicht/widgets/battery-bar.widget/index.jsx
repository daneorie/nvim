// Update every second for the clock. Expensive elements should
// throttle themselves
export const refreshFrequency = 5000; // ms

const USE_BASE_TEN = 10;

const theme = {
  borderSize: 0,
  thickness: "2px",
  chargingColor: "lime",
  chargingSize: "100px",
  green: "#97c475",
  green_threshold: 80,
  yellow: "#e5c07b",
  yellow_threshold: 55,
  orange: "#d09a6a",
  orange_threshold: 30,
  red: "#e06c75",
  screenSize: window.innerWidth,
};

const computeUsedBattery = (usedPercentage) => {
  const paddingPercent = (100 - usedPercentage) / 2;
  return theme.screenSize * (paddingPercent / 100);
};
const computeBatteryColor = (level) => {
  const {
    green,
    green_threshold,
    yellow,
    yellow_threshold,
    orange,
    orange_threshold,
    red,
  } = theme;

  if (level > green_threshold) return green;
  if (level > yellow_threshold) return yellow;
  if (level > orange_threshold) return orange;
  return theme.red;
};

const getBaseBarStyle = () => {
  const height = theme.thickness;

  return {
    bottom: 0,
    position: "fixed",
    overflow: "hidden",
    height,
  };
};

const getBatteryBarStyle = (batteryPercentage) => {
  const background = computeBatteryColor(batteryPercentage);
  const borderSize = theme.borderSize + computeUsedBattery(batteryPercentage);

  return {
    ...getBaseBarStyle(),
    right: borderSize,
    left: borderSize,
    background,
  };
};

const getChargingBarStyle = (chargingStatus) => {
  return chargingStatus
    ? {
        ...getBaseBarStyle(),
        background: theme.chargingColor,
        width: theme.chargingSize,
        animationName: "color",
        animationDuration: "1s",
        animationIterationCount: "infinite",
        animationDirection: "alternate - reverse",
        animationTimingFunction: "ease",
      }
    : {};
};

const getLeftChargingBarStyle = (chargingStatus) => {
  return {
    ...getChargingBarStyle(chargingStatus),
    left: 0,
    marginLeft: 0,
    marginRight: "auto",
  };
};

const getRightChargingBarStyle = (chargingStatus) => {
  return {
    ...getChargingBarStyle(chargingStatus),
    right: 0,
    marginLeft: "auto",
    marginRight: 0,
  };
};

export const command = `echo "[ $(pmset -g batt | egrep '(\\d+)\%' -o | cut -f1 -d%), $(echo "false") ]"`;

export const render = ({ output, error }) => {
  const batteryPercentage = parseInt(output, USE_BASE_TEN);
  const chargingStatus = false;

  if (error) {
    console.log(new Date());
    console.log(error);
    console.log(String(error));
  }

  const batteryBarStyle = getBatteryBarStyle(batteryPercentage);
  const leftChargingBarStyle = getLeftChargingBarStyle(chargingStatus);
  const rightChargingBarStyle = getRightChargingBarStyle(chargingStatus);

  return (
		<div>
			<div style={batteryBarStyle} />
			<div style={leftChargingBarStyle} />
			<div style={rightChargingBarStyle} />
		</div>
  );
};
