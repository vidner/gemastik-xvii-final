import LoginRegister from "@/pages/login-register";
import { createLazyFileRoute } from "@tanstack/react-router";

export const Route = createLazyFileRoute("/login")({
	component: () => (
		<div className="flex justify-center bg-background">
			<LoginRegister />
		</div>
	),
});
