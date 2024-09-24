import Navigation from "@/components/navigation";
import { createRootRoute, Outlet } from "@tanstack/react-router";

function RootComponent() {
	return (
		<div className="container mx-auto py-8 px-4">
			<Navigation />
			<Outlet />
		</div>
	);
}

export const Route = createRootRoute({
	component: () => <RootComponent />,
});
