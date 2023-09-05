import * as fcl from "@onflow/fcl";
import { useEffect, useState } from "react";
import getNameScript from "../cadence/scripts/HOTF_getName.cdc";
import getHandScript from "../cadence/scripts/HOTF_getHand.cdc";
import getManaScript from "../cadence/scripts/HOTF_getMana.cdc";
import useCurrentUser from "../hooks/useCurrentUser";

interface GameState {
  name: string;
  mana: number;
  hand: any[];
}

export default function useGameState(txId: string): GameState {
  //We send in the transaction ID to trigger a re-render when the transaction is sealed
  const [gameState, setGameState] = useState<GameState>({
    name: "",
    mana: 0,
    hand: [],
  });
  const user = useCurrentUser();

  useEffect(() => {
    if (!user || !user.addr) return;
    async function getGameData(script) {
      const res = await fcl.query({
        cadence: script,
        args: (arg, t) => [arg(user.addr, t.Address)],
      });
      return res;
    }
    async function getAllGameData() {
      const name = await getGameData(getNameScript);
      const hand = await getGameData(getHandScript);
      const mana = await getGameData(getManaScript);
      setGameState({
        name: name,
        hand: hand,
        mana: mana,
      });
    }
    getAllGameData();
  }, [user, txId]);

  return gameState;
}
