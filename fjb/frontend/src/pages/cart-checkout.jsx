import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { useCallback } from "react";
import { Loader2, Trash2 } from "lucide-react";
import {
	Card,
	CardContent,
	CardFooter,
	CardHeader,
	CardTitle,
} from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import {
	Table,
	TableBody,
	TableCell,
	TableHead,
	TableHeader,
	TableRow,
} from "@/components/ui/table";
import {
	Tooltip,
	TooltipContent,
	TooltipProvider,
	TooltipTrigger,
} from "@/components/ui/tooltip";
import httpClient from "@/lib/httpClient";
import useAuth from "@/hooks/useAuth";

export default function CartCheckout() {
	const auth = useAuth();
	const queryClient = useQueryClient();

	const { isLoading, data: cart } = useQuery({
		queryKey: ["cart"],
		queryFn: () => httpClient("/api/cart").json(),
		enabled: auth.isSuccess,
	});

	const { mutate } = useMutation({
		mutationKey: ["delete-cart"],
		mutationFn: (id) =>
			httpClient
				.delete("/api/cart", {
					searchParams: new URLSearchParams([["id", id]]),
				})
				.json(),
		onSuccess: async () => {
			queryClient.invalidateQueries({
				queryKey: ["cart"],
			});
		},
	});

	const calculateTotal = () => {
		return cart ? cart.items.reduce((total, item) => total + item.price, 0) : 0;
	};

	const handleDelete = useCallback(
		(index) => {
			mutate(index);
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

	return (
		<>
			{!cart || !cart.items || cart.items.length === 0 ? (
				<div className="flex justify-center items-center">
					Your cart is empty
				</div>
			) : (
				<div className="grid grid-cols-1 md:grid-cols-3 gap-6">
					<Card className="md:col-span-2">
						<CardHeader>
							<CardTitle>Your Items</CardTitle>
						</CardHeader>
						<CardContent>
							<Table>
								<TableHeader>
									<TableRow>
										<TableHead>Item</TableHead>
										<TableHead>Price</TableHead>
										<TableHead className="text-right">Action</TableHead>
									</TableRow>
								</TableHeader>
								<TableBody>
									{cart.items.map((item) => (
										<TableRow key={item.id}>
											<TableCell>{item.name}</TableCell>
											<TableCell>${item.price.toFixed(2)}</TableCell>
											<TableCell className="text-right">
												<Button
													variant="destructive"
													onClick={() => handleDelete(item.id)}
												>
													<Trash2 className="w-4 h-4" />
												</Button>
											</TableCell>
										</TableRow>
									))}
								</TableBody>
							</Table>
						</CardContent>
					</Card>
					<Card className="h-fit">
						<CardHeader>
							<CardTitle>Order Summary</CardTitle>
						</CardHeader>
						<CardContent>
							<div className="space-y-2">
								<div className="flex justify-between">
									<span>Subtotal</span>
									<span>${calculateTotal().toFixed(2)}</span>
								</div>
								<div className="flex justify-between">
									<span>Shipping</span>
									<span>Free</span>
								</div>
								<div className="flex justify-between font-bold">
									<span>Total</span>
									<span>${calculateTotal().toFixed(2)}</span>
								</div>
							</div>
						</CardContent>
						<CardFooter>
							<TooltipProvider>
								<Tooltip>
									<TooltipTrigger asChild>
										<span className="inline-block w-full">
											<Button
												variant="outline"
												disabled
												className="cursor-not-allowed w-full"
											>
												{/* TODO: create checkout */}
												<span>Proceed to Payment</span>
											</Button>
										</span>
									</TooltipTrigger>
									<TooltipContent>
										<p>This action is currently unavailable</p>
									</TooltipContent>
								</Tooltip>
							</TooltipProvider>
						</CardFooter>
					</Card>
				</div>
			)}
		</>
	);
}
