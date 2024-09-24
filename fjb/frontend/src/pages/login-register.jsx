import { useRef } from "react";
import { useMutation, useQueryClient } from "@tanstack/react-query";
import { useNavigate } from "@tanstack/react-router";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import {
	Card,
	CardContent,
	CardDescription,
	CardHeader,
	CardTitle,
} from "@/components/ui/card";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import httpClient from "@/lib/httpClient";

export default function LoginRegister() {
	const usernameRef = useRef();
	const passwordRef = useRef();
	const queryClient = useQueryClient();
	const navigate = useNavigate();
	const { isLoading, mutate } = useMutation({
		mutationKey: ["login"],
		mutationFn: (data) => httpClient.post("/api/login", { json: data }).json(),
		onSettled(data, err) {
			if (err || data?.error) {
				queryClient.setQueryData(["user"], null);
				return;
			}
			queryClient.setQueryData(["user"], data);
			navigate({ to: "/" });
		},
		retry: false,
	});

	async function onSubmit(event) {
		event.preventDefault();
		const username = usernameRef.current.value;
		const password = passwordRef.current.value;
		mutate({ username, password });
	}

	return (
		<Card className="w-[350px]">
			<CardHeader>
				<CardTitle>Account</CardTitle>
				<CardDescription>Login or create a new account.</CardDescription>
			</CardHeader>
			<CardContent>
				<Tabs defaultValue="login" className="w-full">
					<TabsList className="grid w-full grid-cols-2">
						<TabsTrigger value="login">Login</TabsTrigger>
						<TabsTrigger value="register">Register</TabsTrigger>
					</TabsList>
					<TabsContent value="login">
						<form onSubmit={onSubmit}>
							<div className="grid gap-2">
								<div className="grid gap-1">
									<Label htmlFor="username">Username</Label>
									<Input
										id="username"
										placeholder=""
										type="username"
										autoCapitalize="none"
										autoComplete="username"
										autoCorrect="off"
										disabled={isLoading}
										ref={usernameRef}
									/>
								</div>
								<div className="grid gap-1">
									<Label htmlFor="password">Password</Label>
									<Input
										id="password"
										placeholder="********"
										type="password"
										autoCapitalize="none"
										autoComplete="current-password"
										disabled={isLoading}
										ref={passwordRef}
									/>
								</div>
								<Button disabled={isLoading}>
									{isLoading && (
										<div className="mr-2 h-4 w-4 animate-spin rounded-full border-2 border-primary border-r-transparent" />
									)}
									Sign In
								</Button>
							</div>
						</form>
					</TabsContent>
					<TabsContent value="register">
						<form onSubmit={onSubmit}>
							<div className="grid gap-2">
								<div className="grid gap-1">
									<Label htmlFor="username">Username</Label>
									<Input
										id="username"
										placeholder=""
										type="username"
										autoCapitalize="none"
										autoComplete="username"
										autoCorrect="off"
										disabled={isLoading}
									/>
								</div>
								<div className="grid gap-1">
									<Label htmlFor="password">Password</Label>
									<Input
										id="password"
										placeholder="********"
										type="password"
										autoCapitalize="none"
										autoComplete="new-password"
										disabled={isLoading}
									/>
								</div>
								<div className="grid gap-1">
									<Label htmlFor="confirm-password">Confirm Password</Label>
									<Input
										id="confirm-password"
										placeholder="********"
										type="password"
										autoCapitalize="none"
										autoComplete="new-password"
										disabled={isLoading}
									/>
								</div>
								<Button disabled={isLoading}>
									{isLoading && (
										<div className="mr-2 h-4 w-4 animate-spin rounded-full border-2 border-primary border-r-transparent" />
									)}
									Create Account
								</Button>
							</div>
						</form>
					</TabsContent>
				</Tabs>
			</CardContent>
		</Card>
	);
}
