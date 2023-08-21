import containerStyles from "../styles/Container.module.css";
import Game from "./Game";
import Minions from "./Minions";

export default function Container() {
  return (
    <div className={containerStyles.container}>
      <Minions />
      <Game />
    </div>
  );
}
