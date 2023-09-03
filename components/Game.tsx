import * as fcl from "@onflow/fcl";
import Login from "../cadence/transactions/HOTF_login.cdc";
import Draw from "../cadence/transactions/HOTF_draw.cdc";
import GetName from "../cadence/scripts/HOTF_getName.cdc";
import { useEffect, useState } from "react";
import useCurrentUser from "../hooks/useCurrentUser";

export default function Game() {
  const user = useCurrentUser();
  const [name, setName] = useState<string>();
  const [lastTransactionId, setLastTransactionId] = useState<string>();
  const [transactionStatus, setTransactionStatus] = useState<number>();

  useEffect(() => {
    if (user && user.addr) getName();
  }, [user]);

  const login = async () => {
    const transactionId = await fcl.mutate({
      cadence: Login,
      args: (arg, t) => [],
    });
    setLastTransactionId(transactionId);
  };
  const getName = async () => {
    const res = await fcl.query({
      cadence: GetName,
      args: (arg, t) => [arg(user.addr, t.Address)],
    });
    setName(res);
  };

  const draw = async () => {
    const transactionId = await fcl.mutate({
      cadence: Draw,
      args: (arg, t) => [],
    });
    setLastTransactionId(transactionId);
  };

  return (
    <div>
      <h2>Game</h2>
      <p>{"Hi " + name}</p>
      <p>{user.addr}</p>
      <button onClick={() => getName()}>Get Name</button>
      <button onClick={() => login()}>Login</button>
      <button onClick={() => draw()}>Draw</button>
      <h4>Latest Transaction ID: {lastTransactionId}</h4>
      <h4>Latest Transaction Status: {transactionStatus}</h4>
    </div>
  );
}
