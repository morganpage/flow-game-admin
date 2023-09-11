export default function Slot({ index, minion, mutate }) {
  return (
    <div style={{ display: "flex", flexDirection: "column", alignItems: "center", border: "2px solid", minWidth: "100px", minHeight: "100px" }}>
      {index + 1}
      {minion && <img src={minion.imageURL} style={{ width: 60 }} />}
      {/* <p>{minion.name}</p> */}
      {/* <img src={minion.imageURL} style={{ width: 60 }} />
      <p>{minion.description}</p> */}
      {/* <button onClick={() => holdMethod(index, !minion.hold, setTransactionId, setTransactionStatus)}>{minion.hold ? "Release" : "Hold"}</button> */}
    </div>
  );
}
