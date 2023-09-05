import Head from "next/head";
import styles from "../styles/Home.module.css";
import Container from "../components/Container";
import useCurrentUser from "../hooks/useCurrentUser";
import Link from "next/link";
import elementStyles from "../styles/Elements.module.css";

export default function Home() {
  const { loggedIn } = useCurrentUser();

  return (
    <div className={styles.container}>
      <Head>
        <title>Heroes of the Flow</title>
        <meta name="description" content="Heroes of the Flow" />
        <link rel="icon" href="/favicon.ico" />
      </Head>

      <main className={styles.main}>
        <h1 className={styles.title}>
          <Link href="/">Heroes of the Flow</Link>
        </h1>
        <p className={styles.description}>Admin Panel</p>

        {!loggedIn ? (
          <p>You must log in!</p>
        ) : (
          <div style={{ display: "flex", flexDirection: "column", gap: "10px" }}>
            <Link href="/minionPage" className={elementStyles.button}>
              Minions
            </Link>
            <Link href="/gamePage" className={elementStyles.button}>
              Game
            </Link>
          </div>
        )}
        {/* {loggedIn && <Container />} */}

        {/* <Links /> */}
      </main>
    </div>
  );
}
