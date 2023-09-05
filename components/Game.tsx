import * as fcl from "@onflow/fcl";
import loginTransaction from "../cadence/transactions/HOTF_login.cdc";
import drawTransaction from "../cadence/transactions/HOTF_draw.cdc";
import { useEffect, useState } from "react";
import useCurrentUser from "../hooks/useCurrentUser";
import useGameState from "../hooks/useGameState";
import Card from "./Card";

export default function Game() {
  const [name, setName] = useState<string>("");
  const [lastTransactionId, setLastTransactionId] = useState<string>();
  const [transactionStatus, setTransactionStatus] = useState<number>();
  const gameState = useGameState(lastTransactionId);
  const login = async () => {
    const transactionId = await fcl.mutate({
      cadence: loginTransaction,
      args: (arg, t) => [arg(name, t.String)],
    });
    setLastTransactionId(transactionId);
  };
  const draw = async () => {
    console.log("Draw");
    const transactionId = await fcl.mutate({
      cadence: drawTransaction,
      args: (arg, t) => [],
    });
    setLastTransactionId(transactionId);
  };

  return (
    <div>
      {!gameState.name && (
        <div>
          <h2>First you must log in to the game</h2>
          <button onClick={() => login()}>Login to Game</button>
          <input name="name" value={name} type="text" onChange={(e) => setName(e.target.value)} placeholder="Type Name" />
        </div>
      )}
      {gameState.name && (
        <div>
          <h2>Welcome back {gameState.name}, let's carry on with the game</h2>
          <p>Mana: {gameState.mana}</p>
          <p>Hand: </p>
          {gameState.hand && gameState.hand.map((minion: any) => <Card key={minion.name} minion={minion} />)}
          <button onClick={() => draw()}>Draw</button>
        </div>
      )}

      {/* <p>{"Hi " + name}</p>
      <p>{user.addr}</p>
      <button onClick={() => getName()}>Get Name</button>
      <button onClick={() => login()}>Login</button>
      <button onClick={() => draw()}>Draw</button>
      <h4>Latest Transaction ID: {lastTransactionId}</h4>
      <h4>Latest Transaction Status: {transactionStatus}</h4> */}

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
