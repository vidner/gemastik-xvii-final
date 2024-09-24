import { createRouter } from "@tanstack/react-router";
import { routeTree } from "@/routeTree.gen";

const router = createRouter({
	routeTree,
	context: {
		auth: null,
		queryClient: null,
	},
});

export default router;
