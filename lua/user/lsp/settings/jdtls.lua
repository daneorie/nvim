return {
	cmd = { 'jdtls' },
	init_options = {
		bundles = {
			vim.fn.glob("path/to/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar")
		}
	}
}
