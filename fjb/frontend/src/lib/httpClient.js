import ky from "ky";

export default ky.create({
	credentials: "include",
	retry: {
		limit: 1,
		statusCodes: [500, 504],
	},
});
