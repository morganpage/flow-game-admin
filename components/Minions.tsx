import { useEffect, useState } from "react";
import { addMinion, setMinion, deleteMinion, importMinions } from "../utils/contractMethods";
import useMinions from "../hooks/useMinions";

export default function Minions() {
  const [minions, setMinions] = useState<any[]>([]);
  const { data, isError, isLoading, mutate } = useMinions();

  useEffect(() => {
    if (data) setMinions(data);
  }, [data]);

  const addMinionHelper = async (e: any) => {
    e.preventDefault();
    addMinion(e.target.name.value, mutate);
    e.target.name.value = "";
  };

  const onChangeInput = async (e: any, minionName: any) => {
    const { name, value } = e.target;
    console.log(name, value);
    const editedMinions = minions.map((minion) => (minion.name === minionName ? { ...minion, [name]: value, changed: true } : minion));
    console.log(editedMinions);
    setMinions(editedMinions);
  };

  if (isLoading) return <div>Loading...</div>;

  return (
    <div>
      <div style={{ display: "flex", justifyContent: "center", alignItems: "center", gap: "20px" }}>
        <h2>Minions</h2>
        <button style={{ height: "40px" }} onClick={() => importMinions(mutate)}>
          Import Minions
        </button>
      </div>
      <div>
        <form onSubmit={addMinionHelper}>
          <input type="text" id="name" placeholder="Add a Minion" />
          <button type="submit">+</button>
        </form>
        <h4>Minions on Chain: {minions?.length}</h4>
        <table>
          <thead>
            <tr>
              <th></th>
              <th>Name</th>
              <th>Description</th>
              <th>Attack</th>
              <th>Health</th>
              <th>Image URL</th>
            </tr>
          </thead>
          <tbody>
            {minions.map((minion) => (
              <tr key={minion.name}>
                <td style={{ padding: 0 }}>
                  <img src={minion.imageURL} style={{ width: 40 }} />
                </td>
                <td>{minion.name}</td>
                <td>
                  <input name="description" value={minion.description} type="text" onChange={(e) => onChangeInput(e, minion.name)} placeholder="Type Description" />
                </td>
                <td>
                  <input name="attack" value={minion.attack} type="text" onChange={(e) => onChangeInput(e, minion.name)} placeholder="Type Attack" style={{ width: 50 }} />
                </td>
                <td>
                  <input name="health" value={minion.health} type="text" onChange={(e) => onChangeInput(e, minion.name)} placeholder="Type Health" style={{ width: 50 }} />
                </td>
                <td>
                  <input name="imageURL" value={minion.imageURL} type="text" onChange={(e) => onChangeInput(e, minion.name)} placeholder="Type Image URL" />
                </td>
                <td>
                  <button onClick={() => setMinion(minion, mutate)} disabled={!minion.changed}>
                    Update
                  </button>
                  <button onClick={() => deleteMinion(minion.name, mutate)}>x</button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}
