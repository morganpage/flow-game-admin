import * as fcl from "@onflow/fcl";
//MINIONS
import getMinionsScript from "../cadence/scripts/HOTF_getMinions.cdc";
import setMinionTransaction from "../cadence/transactions/HOTF_setMinion.cdc";
import setMinionsTransaction from "../cadence/transactions/HOTF_setMinions.cdc";
import addMinionTransaction from "../cadence/transactions/HOTF_addMinion.cdc";
import deleteMinionTransaction from "../cadence/transactions/HOTF_deleteMinion.cdc";
//GAME
import loginTransaction from "../cadence/transactions/HOTF_login.cdc";
import drawTransaction from "../cadence/transactions/HOTF_draw.cdc";
import holdTransaction from "../cadence/transactions/HOTF_hold.cdc";
import restartTransaction from "../cadence/transactions/HOTF_restart.cdc";

import { adminAuthorizationFunction } from "../utils/authFunctions";
import minionData from "../data/minions.json";

const flowNetwork = process.env.NEXT_PUBLIC_FLOW_NETWORK;

const setTransactionIdAndStatus = (transactionId, setTransactionId, setTransactionStatus) => {
  setTransactionId(transactionId);
  fcl.tx(transactionId).subscribe((res) => {
    if (fcl.tx.isSealed(res)) {
      console.log("Transaction Sealed");
      setTransactionStatus("Sealed");
    }
  });
};

// MINION ADMIN

export const importMinions = async (setTransactionId, setTransactionStatus) => {
  console.log(minionData);
  let names = minionData.map((minion) => minion.name);
  let descriptions = minionData.map((minion) => minion.description);
  let imageURLs = minionData.map((minion) => minion.imageURL);
  let attacks = minionData.map((minion) => minion.attack);
  let healths = minionData.map((minion) => minion.health);
  setTransactionStatus("Pending...");
  let mutateArgs = {
    cadence: setMinionsTransaction,
    args: (arg, t) => [arg(names, t.Array(t.String)), arg(descriptions, t.Array(t.String)), arg(imageURLs, t.Array(t.String)), arg(attacks, t.Array(t.UInt8)), arg(healths, t.Array(t.UInt8))],
  };
  if (flowNetwork === "local") mutateArgs["authorizations"] = [adminAuthorizationFunction];
  const transactionId = await fcl.mutate(mutateArgs);
  setTransactionIdAndStatus(transactionId, setTransactionId, setTransactionStatus);
};

export const setMinion = async (minion, setTransactionId, setTransactionStatus) => {
  setTransactionStatus("Pending...");
  let mutateArgs = {
    cadence: setMinionTransaction,
    args: (arg, t) => [arg(minion.name, t.String), arg(minion.description, t.String), arg(minion.imageURL, t.String), arg(minion.attack, t.UInt8), arg(minion.health, t.UInt8)],
  };
  if (flowNetwork === "local") mutateArgs["authorizations"] = [adminAuthorizationFunction];
  const transactionId = await fcl.mutate(mutateArgs);
  setTransactionIdAndStatus(transactionId, setTransactionId, setTransactionStatus);
};

export const addMinion = async (minionName, setTransactionId, setTransactionStatus) => {
  setTransactionStatus("Pending...");
  let mutateArgs = {
    cadence: addMinionTransaction,
    args: (arg, t) => [arg(minionName, t.String)],
  };
  if (flowNetwork === "local") mutateArgs["authorizations"] = [adminAuthorizationFunction];
  const transactionId = await fcl.mutate(mutateArgs);
  setTransactionIdAndStatus(transactionId, setTransactionId, setTransactionStatus);
};

export const deleteMinion = async (minionName, setTransactionId, setTransactionStatus) => {
  setTransactionStatus("Pending...");
  let mutateArgs = {
    cadence: deleteMinionTransaction,
    args: (arg, t) => [arg(minionName, t.String)],
  };
  if (flowNetwork === "local") mutateArgs["authorizations"] = [adminAuthorizationFunction];
  const transactionId = await fcl.mutate(mutateArgs);
  setTransactionIdAndStatus(transactionId, setTransactionId, setTransactionStatus);
};

// GAME
export const restartMethod = async (name: string, setTransactionId, setTransactionStatus) => {
  console.log("restartMethod " + name);
  setTransactionStatus("Pending...");
  let mutateArgs = {
    cadence: restartTransaction,
    args: (arg, t) => [arg(name, t.String)],
  };
  if (flowNetwork === "local") mutateArgs["authorizations"] = [adminAuthorizationFunction];
  const transactionId = await fcl.mutate(mutateArgs);
  setTransactionId(transactionId);
  fcl.tx(transactionId).subscribe((res) => {
    if (fcl.tx.isSealed(res)) {
      console.log("Transaction Sealed");
      setTransactionStatus("Sealed");
    }
  });
};

export const loginMethod = async (name: string, setTransactionId, setTransactionStatus) => {
  console.log("Login " + name);
  let mutateArgs = {
    cadence: loginTransaction,
    args: (arg, t) => [arg(name, t.String)],
  };
  if (flowNetwork === "local") mutateArgs["authorizations"] = [adminAuthorizationFunction];
  setTransactionStatus("Pending...");
  const transactionId = await fcl.mutate(mutateArgs);
  setTransactionId(transactionId);
  fcl.tx(transactionId).subscribe((res) => {
    if (fcl.tx.isSealed(res)) {
      console.log("Transaction Sealed");
      setTransactionStatus("Sealed");
    }
  });
};

export const holdMethod = async (index: Number, hold, setTransactionId, setTransactionStatus) => {
  console.log("Hold" + index + " " + hold);
  setTransactionStatus("Pending...");
  let mutateArgs = {
    cadence: holdTransaction,
    args: (arg, t) => [arg(index, t.Int), arg(hold, t.Bool)],
  };
  if (flowNetwork === "local") mutateArgs["authorizations"] = [adminAuthorizationFunction];
  const transactionId = await fcl.mutate(mutateArgs);
  setTransactionId(transactionId);
  fcl.tx(transactionId).subscribe((res) => {
    if (fcl.tx.isSealed(res)) {
      console.log("Transaction Sealed");
      setTransactionStatus("Sealed");
    }
  });
};

export const drawMethod = async (setTransactionId, setTransactionStatus) => {
  console.log("Draw");
  setTransactionStatus("Pending...");
  let mutateArgs = {
    cadence: drawTransaction,
    args: (arg, t) => [],
  };
  if (flowNetwork === "local") mutateArgs["authorizations"] = [adminAuthorizationFunction];
  const transactionId = await fcl.mutate(mutateArgs);
  setTransactionId(transactionId);
  fcl.tx(transactionId).subscribe((res) => {
    if (fcl.tx.isSealed(res)) {
      console.log("Transaction Sealed");
      setTransactionStatus("Sealed");
    }
  });
};
