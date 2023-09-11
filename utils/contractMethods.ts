import * as fcl from "@onflow/fcl";
//MINIONS
import setMinionTransaction from "../cadence/transactions/HOTF_setMinion.cdc";
import setMinionsTransaction from "../cadence/transactions/HOTF_setMinions.cdc";
import addMinionTransaction from "../cadence/transactions/HOTF_addMinion.cdc";
import deleteMinionTransaction from "../cadence/transactions/HOTF_deleteMinion.cdc";
//GAME
import loginTransaction from "../cadence/transactions/HOTF_login.cdc";
import drawTransaction from "../cadence/transactions/HOTF_draw.cdc";
import holdTransaction from "../cadence/transactions/HOTF_hold.cdc";
import restartTransaction from "../cadence/transactions/HOTF_restart.cdc";
import placeTransaction from "../cadence/transactions/HOTF_place.cdc";

import { adminAuthorizationFunction } from "../utils/authFunctions";
import minionData from "../data/minions.json";

//const flowNetwork = process.env.NEXT_PUBLIC_FLOW_NETWORK;
const autoSign = process.env.NEXT_PUBLIC_AUTOSIGN === "true";

// MINION ADMIN

export const importMinions = async (mutate) => {
  console.log(minionData);
  let names = minionData.map((minion) => minion.name);
  let descriptions = minionData.map((minion) => minion.description);
  let imageURLs = minionData.map((minion) => minion.imageURL);
  let attacks = minionData.map((minion) => minion.attack);
  let healths = minionData.map((minion) => minion.health);
  let mutateArgs = {
    cadence: setMinionsTransaction,
    args: (arg, t) => [arg(names, t.Array(t.String)), arg(descriptions, t.Array(t.String)), arg(imageURLs, t.Array(t.String)), arg(attacks, t.Array(t.UInt8)), arg(healths, t.Array(t.UInt8))],
  };
  if (autoSign) mutateArgs["authorizations"] = [adminAuthorizationFunction];
  const transactionId = await fcl.mutate(mutateArgs);
  mutateOnSealed(transactionId, mutate);
};

export const setMinion = async (minion, mutate) => {
  let mutateArgs = {
    cadence: setMinionTransaction,
    args: (arg, t) => [arg(minion.name, t.String), arg(minion.description, t.String), arg(minion.imageURL, t.String), arg(minion.attack, t.UInt8), arg(minion.health, t.UInt8)],
  };
  if (autoSign) mutateArgs["authorizations"] = [adminAuthorizationFunction];
  const transactionId = await fcl.mutate(mutateArgs);
  mutateOnSealed(transactionId, mutate);
};

export const addMinion = async (minionName, mutate) => {
  let mutateArgs = {
    cadence: addMinionTransaction,
    args: (arg, t) => [arg(minionName, t.String)],
  };
  if (autoSign) mutateArgs["authorizations"] = [adminAuthorizationFunction];
  const transactionId = await fcl.mutate(mutateArgs);
  mutateOnSealed(transactionId, mutate);
};

export const deleteMinion = async (minionName, mutate) => {
  let mutateArgs = {
    cadence: deleteMinionTransaction,
    args: (arg, t) => [arg(minionName, t.String)],
  };
  if (autoSign) mutateArgs["authorizations"] = [adminAuthorizationFunction];
  const transactionId = await fcl.mutate(mutateArgs);
  mutateOnSealed(transactionId, mutate);
};

// GAME
export const restartMethod = async (name: string, mutate) => {
  console.log("restartMethod " + name);
  let mutateArgs = {
    cadence: restartTransaction,
    args: (arg, t) => [arg(name, t.String)],
  };
  if (autoSign) mutateArgs["authorizations"] = [adminAuthorizationFunction];
  const transactionId = await fcl.mutate(mutateArgs);
  mutateOnSealed(transactionId, mutate);
};

const mutateOnSealed = (transactionId, mutate) => {
  fcl.tx(transactionId).subscribe((res) => {
    if (fcl.tx.isSealed(res)) {
      mutate();
    }
  });
};

export const loginMethod = async (name: string, mutate) => {
  console.log("Login " + name);
  let mutateArgs = {
    cadence: loginTransaction,
    args: (arg, t) => [arg(name, t.String)],
  };
  if (autoSign) mutateArgs["authorizations"] = [adminAuthorizationFunction];
  const transactionId = await fcl.mutate(mutateArgs);
  mutateOnSealed(transactionId, mutate);
};

export const holdMethod = async (index: Number, hold, mutate) => {
  console.log("Hold" + index + " " + hold);
  let mutateArgs = {
    cadence: holdTransaction,
    args: (arg, t) => [arg(index, t.Int), arg(hold, t.Bool)],
  };
  if (autoSign) mutateArgs["authorizations"] = [adminAuthorizationFunction];
  const transactionId = await fcl.mutate(mutateArgs);
  mutateOnSealed(transactionId, mutate);
};

export const drawMethod = async (mutate) => {
  console.log("Draw");
  let mutateArgs = {
    cadence: drawTransaction,
    args: (arg, t) => [],
  };
  if (autoSign) mutateArgs["authorizations"] = [adminAuthorizationFunction];
  const transactionId = await fcl.mutate(mutateArgs);
  mutateOnSealed(transactionId, mutate);
};

export const placeMethod = async (battleIndex: String, handIndex: String, mutate) => {
  //battleIndex: Int,handIndex: Int
  console.log("Place: battleIndex: " + battleIndex + " handIndex: " + handIndex);
  let mutateArgs = {
    cadence: placeTransaction,
    args: (arg, t) => [arg(battleIndex, t.Int), arg(handIndex, t.Int)],
  };
  if (autoSign) mutateArgs["authorizations"] = [adminAuthorizationFunction];
  const transactionId = await fcl.mutate(mutateArgs);
  mutateOnSealed(transactionId, mutate);
};
