/* export const setupStateMiddleware: Middleware<AppState> = async (
	context: Context<AppState>,
	next,
) => {
	context.state.response = {
		status: {
			timestamp: new Date().toISOString(),
			success: false,
			elapsed: 0,
			error_code: null,
			error_message: null,
		},
		data: null,
	};
	await next();
	context.response.status = 200;
	context.response.body = context.state.response;
}; */
