/datum/error_viewer/browse_to(client/user, html)
	var/datum/browser/browser = new(user.mob, "error_viewer", null, 1050, 625)
	browser.set_content(html)
	browser.set_head_content({"
	<style>
	.runtime
	{
		background-color: #171717;
		border: solid 1px #202020;
		font-family: "Courier New";
		padding-left: 10px;
		color: #CCCCCC;
	}
	.runtime_line
	{
		margin-bottom: 10px;
		display: inline-block;
	}
	</style>
	<script>
		let LOG_FILE = null;
		function set_log(path) {
			LOG_FILE = path;
		}
		document.addEventListener("DOMContentLoaded", (ev) => {
		const clicky = document.getElementById("open_external_log_viewer");

		clicky.addEventListener("click", (ev) => {
			(async () => {
				const start = Date.now();
				const timeoutMs = 10_000;
				const pollIntervalMs = 250;
				while (Date.now() - start < timeoutMs) {
					try {
						if (!LOG_FILE) {
							await new Promise(r => setTimeout(r, pollIntervalMs));
							continue;
						}
						const head = await fetch(LOG_FILE, { method: "HEAD" });
						if (head.ok) {
							const res = await fetch(LOG_FILE);
							LOG_FILE = null;
							const logtext = await res.text();

							const params = new URLSearchParams()
							params.set("log_text", logtext);
							params.set("log_name", '[get_log_file_path()]');
							const options = \[
								"ignore_non_runtimes",
								"organized",
								"enable_back_button",
								"disable_upload",
							];
							for (const option of options)
							  params.set(option, true);
							window.location.href = `https://monkestation.github.io/ss13-log-viewer/#${params.toString()}`;
							return;
						}
					} catch (_) {	}
					await new Promise(r => setTimeout(r, pollIntervalMs));
				}
				console.error("Timed out waiting for current_log.json");
			})()
		});
	})
	</script>
	"})
	browser.open()


/datum/error_viewer/build_header(datum/error_viewer/back_to, linear)
	// Common starter HTML for show_to
	. = ""

	if (istype(back_to))
		. += back_to.make_link("<b>&lt;&lt;&lt;</b>", null, linear)

	. += {"
		<div style="display: flex; justify-content: space-between">
			<div id="funky">
				[istype(back_to) ? back_to.make_link("<b>&lt;&lt;&lt;</b>", null, linear) : ""]
				[make_link("Refresh")]
				<a id='open_external_log_viewer' href='byond://?_src_=holder;[HrefToken()];viewruntime=[REF(src)];viewruntime_externallog=1'>Enhanced Log Viewer (Does not persist logs)</a>
			</div>
			<div id="fresh">
				Save log file:
				<a href='byond://?_src_=holder;[HrefToken()];viewruntime=[REF(src)];viewruntime_savelog=txt'>.log</a>
				<a href='byond://?_src_=holder;[HrefToken()];viewruntime=[REF(src)];viewruntime_savelog=json'>.json</a>
			</div>
			<!-- beats -->
		</div>
		<br>
	"}

/datum/error_viewer/proc/get_log_file_path(client/user)
	return "[GLOB.log_directory]/[get_category_logfile(/datum/log_category/debug_runtime)].log"

/datum/error_viewer/proc/send_log_file(client/user)
	if(!user)
		return
	var/log_file = file("[get_log_file_path()].json")
	var/unique_filename = "current_log-[random_string(4, GLOB.hex_characters)].json"
	to_chat(user, span_notice("Sending log file '[get_log_file_path()].json'..."))
	DIRECT_OUTPUT(user, browse_rsc(log_file, unique_filename))
	DIRECT_OUTPUT(user, output(unique_filename, "error_viewer.browser:set_log"))

/datum/error_viewer/proc/save_log(client/user, type = "txt")
	var/file
	switch(type)
		if("txt")
			file = get_log_file_path()
			DIRECT_OUTPUT(user, ftp(file, "runtime.log"))
			return
		if("json")
			file = "[get_log_file_path()].json"
			DIRECT_OUTPUT(user, ftp(file, "runtime.log.json"))
			return
