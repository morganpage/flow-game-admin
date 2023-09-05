import Head from "next/head";
import styles from "../styles/Home.module.css";
import useCurrentUser from "../hooks/useCurrentUser";
import Game from "../components/Game";
import Link from "next/link";

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

        {loggedIn && <Game />}
      </main>
    </div>
  );
}
