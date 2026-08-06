return {
  {
    "nvim-neotest/neotest",
    opts = {
      log_level = 1,
      adapters = {
        ["neotest-pest"] = {
          sail_enabled = true,
          sail_project_path = "/skp",
          pest_cmd = { "./xenv", "php", "vendor/bin/pest" },
        },
      },
    },
  },
}
