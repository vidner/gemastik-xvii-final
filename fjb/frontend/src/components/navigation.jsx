import { useCallback, useState, useEffect } from "react";
import {
	Loader2,
	ShoppingBag,
	ShoppingCart,
	LogOut,
	LogIn,
	Plus,
	Eye,
	EyeOff,
} from "lucide-react";
import { useMutation, useQueryClient } from "@tanstack/react-query";
import { Link, useNavigate, useLocation } from "@tanstack/react-router";
import { Button } from "@/components/ui/button";
import { Label } from "@/components/ui/label";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";
import {
	Dialog,
	DialogContent,
	DialogDescription,
	DialogFooter,
	DialogHeader,
	DialogTitle,
	DialogTrigger,
} from "@/components/ui/dialog";

import useAuth from "@/hooks/useAuth";
import router from "@/lib/router";
import httpClient from "@/lib/httpClient";

function AuthButton() {
	const navigate = useNavigate();

	const { isPending, authSuccess } = useAuth();
	const queryClient = useQueryClient();

	const logout = useCallback(
		(e) => {
			e.preventDefault();
			document.cookie = "session=";
			queryClient.invalidateQueries({ queryKey: ["user"] });
			router.invalidate();
			navigate({ to: "/login" });
		},
		[queryClient, navigate],
	);

	if (isPending) {
		return (
			<Button className="flex items-center gap-2" disabled>
				<Loader2 className="h-5 w-5 animate-spin" />
				<span className="hidden sm:inline">Loading</span>
			</Button>
		);
	}

	if (authSuccess) {
		return (
			<Button className="flex items-center gap-2" onClick={logout}>
				<LogOut className="h-5 w-5" />
				<span className="hidden sm:inline">Logout</span>
			</Button>
		);
	}

	return (
		<Link to="/login">
			<Button className="flex items-center gap-2">
				<LogIn className="h-5 w-5" />
				<span className="hidden sm:inline">Login</span>
			</Button>
		</Link>
	);
}

export default function Navigation() {
	const [data, setData] = useState({
		name: "",
		description: "",
		valuable: "",
		price: "",
	});
	const [valueHidden, setValueHidden] = useState(true);
	const { pathname } = useLocation();
	const [dialogClass, setDialogClass] = useState(null);
	const [open, setOpen] = useState(false);
	const { isSuccess: authSuccess } = useAuth();
	const queryClient = useQueryClient();

	const { isPending, mutate } = useMutation({
		mutationKey: ["post-add-item"],
		mutationFn: (data) => httpClient.post("/api/catalog", { json: data }),
		onSuccess: () => {
			queryClient.invalidateQueries({ queryKey: ["items"] });
			setOpen(false);
		},
	});

	useEffect(() => {
		if (pathname === "/" && authSuccess) {
			setDialogClass("flex items-center gap-2");
		} else {
			setDialogClass("hidden");
		}
	}, [pathname, authSuccess]);

	const handleChange = (event) => {
		const { name, value } = event.target;
		setData((prev) => ({ ...prev, [name]: value }));
	};

	const handleSubmit = (event) => {
		event.preventDefault();
		mutate(data);
	};

	const toggleValuableVisibility = () => {
		setValueHidden((prev) => !prev);
	};

	return (
		<div className="flex justify-between items-center mb-6 flex-wrap gap-4">
			<Link to="/">
				<h1 className="text-3xl font-bold">FJB</h1>
			</Link>
			<div className="flex gap-2">
				<Dialog open={open} onOpenChange={setOpen}>
					<DialogTrigger asChild>
						<Button className={dialogClass}>
							<Plus className="h-5 w-5" />
							<span className="hidden sm:inline">Add Item</span>
						</Button>
					</DialogTrigger>
					<DialogContent className="sm:max-w-[425px]">
						<DialogHeader>
							<DialogTitle>Add New Item</DialogTitle>
							<DialogDescription>
								Enter the details of the item you want to add to the
								marketplace.
							</DialogDescription>
						</DialogHeader>
						<form onSubmit={handleSubmit}>
							<div className="grid gap-4 py-4">
								<div className="grid grid-cols-4 items-center gap-4">
									<Label htmlFor="name" className="text-right">
										Name
									</Label>
									<Input
										id="name"
										name="name"
										value={data.name}
										onChange={handleChange}
										className="col-span-3"
									/>
								</div>
								<div className="grid grid-cols-4 items-center gap-4">
									<Label htmlFor="description" className="text-right">
										Description
									</Label>
									<Textarea
										id="description"
										name="description"
										value={data.description}
										onChange={handleChange}
										className="col-span-3"
									/>
								</div>
								<div className="grid grid-cols-4 items-center gap-4">
									<Label htmlFor="valuable" className="text-right">
										Valuable
									</Label>
									<div className="col-span-3 flex">
										<Input
											id="valuable"
											name="valuable"
											type={valueHidden ? "text" : "password"}
											value={data.valuable}
											onChange={handleChange}
											className="flex-grow"
										/>
										<Button
											type="button"
											variant="outline"
											size="icon"
											onClick={toggleValuableVisibility}
											className="ml-2"
										>
											{valueHidden ? (
												<EyeOff className="h-4 w-4" />
											) : (
												<Eye className="h-4 w-4" />
											)}
										</Button>
									</div>
								</div>
								<div className="grid grid-cols-4 items-center gap-4">
									<Label htmlFor="price" className="text-right">
										Price
									</Label>
									<Input
										id="price"
										name="price"
										value={data.price}
										onChange={handleChange}
										type="number"
										className="col-span-3"
									/>
								</div>
							</div>
							<DialogFooter>
								<Button type="submit" disabled={isPending}>
									{isPending && (
										<div className="mr-2 h-4 w-4 animate-spin rounded-full border-2 border-primary border-r-transparent" />
									)}
									Submit
								</Button>
							</DialogFooter>
						</form>
					</DialogContent>
				</Dialog>
				<Link to="/">
					<Button variant="outline" className="flex items-center gap-2">
						<ShoppingBag className="h-5 w-5" />
						<span className="hidden sm:inline">Marketplace</span>
					</Button>
				</Link>
				<Link to="/cart">
					<Button variant="outline" className="flex items-center gap-2">
						<ShoppingCart className="h-5 w-5" />
						<span className="hidden sm:inline">Cart</span>
					</Button>
				</Link>
				<AuthButton />
			</div>
		</div>
	);
}
