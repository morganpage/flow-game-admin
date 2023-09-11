import { loginMethod, drawMethod, restartMethod } from "../utils/contractMethods";
import { useState } from "react";
import useGameState from "../hooks/useGameState";
import Card from "./Card";
import Slot from "./Slot";

export default function Game() {
  const [name, setName] = useState<string>("");
  const { gameState, isLoading, isError, mutate } = useGameState();
  if (isLoading) return <div>Loading...</div>;

  return (
    <div>
      <button onClick={() => restartMethod(name, mutate)}>Restart Game</button>
      {!gameState.name && (
        <div>
          <h2>First you must log in to the game</h2>
          <button onClick={() => loginMethod(name, mutate)}>Login to Game</button>
          <input name="name" value={name} type="text" onChange={(e) => setName(e.target.value)} placeholder="Type Name" />
        </div>
      )}
      {gameState.name && (
        <div>
          <h2>Welcome back {gameState.name}, let's carry on with the game</h2>
          <p>Mana: {gameState.mana}</p>
          <button onClick={() => drawMethod(mutate)}>Draw</button>
          <p>Hand: </p>
          <div style={{ display: "flex" }}>{gameState.hand && gameState.hand.map((minion: any, index: Number) => <Card key={minion.name} minion={minion} index={index} mutate={mutate} />)}</div>
          <p>Battle:</p>
          <div style={{ display: "flex" }}>
            {[0, 1, 2, 3, 4].map((index) => (
              <Slot key={index} index={index} minion={gameState.battlefield[index]} mutate={mutate} />
            ))}
          </div>
        </div>
      )}
    </div>
  );
}
