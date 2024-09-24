import httpClient from "@/lib/httpClient";
import { useQuery } from "@tanstack/react-query";

export default function useAuth() {
	return useQuery({
		queryKey: ["user"],
		queryFn: () => httpClient.get("/api/user").json(),
	});
}
