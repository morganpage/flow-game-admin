export default function Card({ minion }) {
  return (
    <div key={minion.name}>
      {minion.name} {minion.description}
    </div>
  );
}
