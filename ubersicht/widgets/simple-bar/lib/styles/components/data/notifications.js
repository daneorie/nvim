export const notificationsStyle = /* css */ `
.notifications {
  flex: 0 0 auto;
  display: flex;
  align-items: stretch;
}
.simple-bar--no-bar-background .notifications {
  padding: 4px 5px;
  background-color: var(--background);
  box-shadow: var(--light-shadow);
  border-radius: var(--bar-radius);
}
.notification {
  position: relative;
  display: flex;
  align-items: center;
  background-color: var(--main-alt);
}
.simple-bar--background-color-as-foreground .notification {
  color: var(--main-alt);
  background-color: transparent;
}
`;
