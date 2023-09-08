import * as fcl from "@onflow/fcl";
import getNameScript from "../cadence/scripts/HOTF_getName.cdc";
import getHandScript from "../cadence/scripts/HOTF_getHand.cdc";
import getManaScript from "../cadence/scripts/HOTF_getMana.cdc";
import useCurrentUser from "../hooks/useCurrentUser";
import useSWR from "swr";

interface GameState {
  name: string;
  mana: number;
  hand: any[];
}
interface GameStateResponse {
  gameState: GameState;
  isLoading: boolean;
  isError: boolean;
  mutate: any;
}

//const fetcher = url => fetch(url).then(r => r.json())
async function getGameData(address, script) {
  const res = await fcl.query({
    cadence: script,
    args: (arg, t) => [arg(address, t.Address)],
  });
  return res;
}

async function getAllGameData(address) {
  console.log("getAllGameData: ", address);
  const name = await getGameData(address, getNameScript);
  const hand = await getGameData(address, getHandScript);
  const mana = await getGameData(address, getManaScript);
  return {
    name: name,
    hand: hand,
    mana: mana,
  };
}

export default function useGameState(): GameStateResponse {
  const user = useCurrentUser();
  const { data, error, isLoading, mutate } = useSWR(user.addr, getAllGameData);
  return {
    gameState: data,
    isLoading: !data || isLoading, // I consider it loading if there is no data yet!!!!
    isError: error,
    mutate,
  };
}
