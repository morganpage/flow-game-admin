import { holdMethod, placeMethod } from "../utils/contractMethods";
import { useState } from "react";

export default function Card({ minion, index, mutate }) {
  const min = 1;
  const max = 5;
  const [battleIndex, setBattleIndex] = useState(1);
  const handleBattleIndexChange = (event) => {
    const battleIndex = Math.max(min, Math.min(max, Number(event.target.value)));
    setBattleIndex(battleIndex);
  };
  return (
    <div style={{ display: "flex", flexDirection: "column", alignItems: "center", border: "2px solid", minWidth: "100px" }}>
      <p>{minion.name}</p>
      <img src={minion.imageURL} style={{ width: 60 }} />
      <p>{minion.description}</p>
      <button onClick={() => holdMethod(index, !minion.hold, mutate)}>{minion.hold ? "Release" : "Hold"}</button>
      <div>
        <button onClick={() => placeMethod((battleIndex - 1).toString(), index, mutate)}>Place</button>
        <input type="number" min={min} max={max} value={battleIndex} onChange={handleBattleIndexChange} />
      </div>
    </div>
  );
}
