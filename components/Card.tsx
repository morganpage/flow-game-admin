import { holdMethod } from "../utils/contractMethods";

export default function Card({ minion, index, mutate }) {
  return (
    <div style={{ display: "flex", flexDirection: "column", alignItems: "center", border: "2px solid", minWidth: "100px" }}>
      <p>{minion.name}</p>
      <img src={minion.imageURL} style={{ width: 60 }} />
      <p>{minion.description}</p>
      <button onClick={() => holdMethod(index, !minion.hold, mutate)}>{minion.hold ? "Release" : "Hold"}</button>
    </div>
  );
}
