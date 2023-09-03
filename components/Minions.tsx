import * as fcl from "@onflow/fcl";
import { useEffect, useState } from "react";
import getMinionsScript from "../cadence/scripts/HOTF_getMinions.cdc";
import setMinionTransaction from "../cadence/transactions/HOTF_setMinion.cdc";
import setMinionsTransaction from "../cadence/transactions/HOTF_setMinions.cdc";
import deleteMinionTransaction from "../cadence/transactions/HOTF_deleteMinion.cdc";
import addMinionTransaction from "../cadence/transactions/HOTF_addMinion.cdc";
import useConfig from "../hooks/useConfig";
import { createExplorerTransactionLink } from "../helpers/links";
import minionData from "../data/minions.json";

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

  const importMinions = async () => {
    console.log(minionData);
    let names = minionData.map((minion) => minion.name);
    let descriptions = minionData.map((minion) => minion.description);
    let imageURLs = minionData.map((minion) => minion.imageURL);
    let attacks = minionData.map((minion) => minion.attack);
    let healths = minionData.map((minion) => minion.health);

    const transactionId = await fcl.mutate({
      cadence: setMinionsTransaction,
      args: (arg, t) => [arg(names, t.Array(t.String)), arg(descriptions, t.Array(t.String)), arg(imageURLs, t.Array(t.String)), arg(attacks, t.Array(t.UInt8)), arg(healths, t.Array(t.UInt8))],
    });
    setLastTransactionId(transactionId);
  };

  const setMinion = async (minion) => {
    const transactionId = await fcl.mutate({
      cadence: setMinionTransaction,
      args: (arg, t) => [arg(minion.name, t.String), arg(minion.description, t.String), arg(minion.imageURL, t.String), arg(minion.attack, t.UInt8), arg(minion.health, t.UInt8)],
    });
    setLastTransactionId(transactionId);
  };

  const deleteMinion = async (minionName) => {
    const transactionId = await fcl.mutate({
      cadence: deleteMinionTransaction,
      args: (arg, t) => [arg(minionName, t.String)],
    });
    setLastTransactionId(transactionId);
  };

  const addMinion = async (e: any) => {
    e.preventDefault();
    const minionName = e.target.name.value;
    const transactionId = await fcl.mutate({
      cadence: addMinionTransaction,
      args: (arg, t) => [arg(minionName, t.String)],
    });
    setLastTransactionId(transactionId);
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
        <button style={{ height: "40px" }} onClick={importMinions}>
          Import Minions
        </button>
      </div>
      {/* <img src="https://drive.google.com/uc?export=view&id=19nLGECEHIBo3H-aT_vvZLetOa-TvCqq8" alt="Flow Logo" className={containerStyles.logo} /> */}
      <div>
        <form onSubmit={addMinion}>
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
                <td>
                  <button onClick={() => setMinion(minion)} disabled={!minion.changed}>
                    Update
                  </button>
                  <button onClick={() => deleteMinion(minion.name)}>x</button>
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
