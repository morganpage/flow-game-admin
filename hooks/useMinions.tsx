import * as fcl from "@onflow/fcl";
import useCurrentUser from "../hooks/useCurrentUser";
import useSWR from "swr";
import getMinionsScript from "../cadence/scripts/HOTF_getMinions.cdc";

async function getMinions() {
  const res = await fcl.query({
    cadence: getMinionsScript,
  });
  res.sort((a, b) => a.name.localeCompare(b.name)); //Sort alphabetically for now
  return res;
}

export default function useMinions() {
  const user = useCurrentUser();
  const { data, error, isLoading, mutate } = useSWR(user.addr, getMinions);
  return {
    data: data,
    isLoading: !data || isLoading, // I consider it loading if there is no data yet!!!!
    isError: error,
    mutate,
  };
}
