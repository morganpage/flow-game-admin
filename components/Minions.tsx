import * as fcl from "@onflow/fcl";
import { useEffect, useState } from "react";
import getMinionsScript from "../cadence/scripts/HOTF_getMinions.cdc";
import useConfig from "../hooks/useConfig";
import { createExplorerTransactionLink } from "../helpers/links";
import { addMinion, setMinion, deleteMinion, importMinions } from "../utils/contractMethods";

export default function Minions() {
  const [minions, setMinions] = useState<any[]>([]);
  const [lastTransactionId, setLastTransactionId] = useState<string>();
  const [transactionStatus, setTransactionStatus] = useState<number>();
  const { network } = useConfig();

  const isEmulator = (network) => network !== "mainnet" && network !== "testnet";
  const isSealed = (statusCode) => statusCode === 4; // 4: 'SEALED'

  useEffect(() => {
    //Just for initial load
    queryChain();
  }, []);

  useEffect(() => {
    //Kicks off when lastTransactionId changes
    if (lastTransactionId) {
      console.log("Last Transaction ID: ", lastTransactionId);
      fcl.tx(lastTransactionId).subscribe((res) => {
        console.log("Transaction Status: ", res.status);
        setTransactionStatus(res.statusString);

        // Query for new chain string again if status is sealed
        if (isSealed(res.status)) {
          queryChain();
        }
      });
    }
  }, [lastTransactionId]);

  const queryChain = async () => {
    const res = await fcl.query({
      cadence: getMinionsScript,
    });
    console.log("Minions: ", res);
    res.sort((a, b) => a.name.localeCompare(b.name)); //Sort alphabetically for now
    setMinions(res);
  };

  // const mutateGreeting = async (event) => {
  //   event.preventDefault();

  //   if (!userGreetingInput.length) {
  //     throw new Error("Please add a new greeting string.");
  //   }

  //   const transactionId = await fcl.mutate({
  //     cadence: UpdateHelloWorld,
  //     args: (arg, t) => [arg(userGreetingInput, t.String)],
  //   });

  //   setLastTransactionId(transactionId);
  // };

  const openExplorerLink = (transactionId, network) => window.open(createExplorerTransactionLink({ network, transactionId }), "_blank");

  const addMinionHelper = async (e: any) => {
    e.preventDefault();
    addMinion(e.target.name.value, setLastTransactionId, setTransactionStatus);
    e.target.name.value = "";
  };

  const onChangeInput = async (e: any, minionName: any) => {
    const { name, value } = e.target;
    console.log(name, value);
    const editedMinions = minions.map((minion) => (minion.name === minionName ? { ...minion, [name]: value, changed: true } : minion));
    console.log(editedMinions);
    setMinions(editedMinions);
  };

  return (
    <div>
      <div style={{ display: "flex", justifyContent: "center", alignItems: "center", gap: "20px" }}>
        <h2>Minions</h2>
        <button style={{ height: "40px" }} onClick={() => importMinions(setLastTransactionId, setTransactionStatus)}>
          Import Minions
        </button>
      </div>
      {/* <img src="https://drive.google.com/uc?export=view&id=19nLGECEHIBo3H-aT_vvZLetOa-TvCqq8" alt="Flow Logo" className={containerStyles.logo} /> */}
      <div>
        <form onSubmit={addMinionHelper}>
          <input type="text" id="name" placeholder="Add a Minion" />
          <button type="submit">+</button>
        </form>
        <h4>Minions on Chain: {minions.length}</h4>
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
                <p>{minion.hold.toString()}</p>
                <td>
                  <button onClick={() => setMinion(minion, setLastTransactionId, setTransactionStatus)} disabled={!minion.changed}>
                    Update
                  </button>
                  <button onClick={() => deleteMinion(minion.name, setLastTransactionId, setTransactionStatus)}>x</button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
      <hr />
      <div>
        {/* <h2>Mutate the Chain</h2>
        {!isEmulator(network) && (
          <h4>
            Latest Transaction ID:{" "}
            <a
              className={elementStyles.link}
              onClick={() => {
                openExplorerLink(lastTransactionId, network);
              }}
            >
              {lastTransactionId}
            </a>
          </h4>
        )} */}
        <h4>Latest Transaction ID: {lastTransactionId}</h4>
        <h4>Latest Transaction Status: {transactionStatus}</h4>
      </div>
    </div>
  );
}
