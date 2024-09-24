import { useCallback } from "react";
import { formatDistanceToNow } from "date-fns";
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { ShoppingBasket, Loader2 } from "lucide-react";
import {
	Card,
	CardContent,
	CardDescription,
	CardFooter,
	CardHeader,
	CardTitle,
} from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import httpClient from "@/lib/httpClient";

export default function MarketplaceListing() {
	const queryClient = useQueryClient();

	const { data, isLoading } = useQuery({
		queryKey: ["items"],
		queryFn: () => httpClient.get("/api/catalog").json(),
	});

	const { mutate } = useMutation({
		mutationKey: ["post-cart"],
		mutationFn: (data) => httpClient.post("/api/cart", { json: data }).json(),
		onSuccess: () => {
			queryClient.invalidateQueries({ queryKey: ["cart"] });
		},
	});

	const handleAddToCart = useCallback(
		(id) => {
			mutate({ item: id });
		},
		[mutate],
	);

	if (isLoading) {
		return (
			<div className="flex items-center justify-center min-h-screen bg-background">
				<Loader2 className="h-8 w-8 animate-spin text-primary" />
			</div>
		);
	}

	if (!data) {
		return (
			<div className="flex justify-center items-center h-screen">
				No data available
			</div>
		);
	}

	return (
		<>
			<div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
				{data.items.map((item) => (
					<Card key={item.id} className="flex flex-col">
						<CardHeader>
							<CardTitle>{item.name}</CardTitle>
							<CardDescription>{item.description}</CardDescription>
						</CardHeader>
						<CardContent className="flex-grow">
							<p className="text-2xl font-bold">${item.price.toFixed(2)}</p>
							<p className="text-sm text-gray-500">
								Posted {formatDistanceToNow(new Date(item.date_posted))} ago
							</p>
						</CardContent>
						<CardFooter className="flex justify-between items-center">
							<Badge variant="secondary">Owner ID: {item.owner}</Badge>
							<Button
								className="flex items-center gap-2"
								onClick={(e) => {
									e.preventDefault();
									console.log(e.target);
									e.target.setAttribute("disabled", "true");
									handleAddToCart(item.id);
									setTimeout(() => {
										e.target.removeAttribute("disabled");
									}, 1000);
								}}
							>
								<ShoppingBasket className="h-5 w-5" />
								<span className="hidden sm:inline">Add to Cart</span>
							</Button>
						</CardFooter>
					</Card>
				))}
			</div>
		</>
	);
}
