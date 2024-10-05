local discord_presence_mode = os.getenv("DISCORD_PRESENCE_MODE")
if discord_presence_mode == nil then
  discord_presence_mode = "office"
end

return {
  {
    "andweeb/presence.nvim",
    opts = {
      main_image = "neovim",
      neovim_image_text = "King god general majesty editor",
      debounce_timeout = 100,
      show_button = discord_presence_mode == "home",

      editing_text = "" .. (discord_presence_mode == "home" and "Editing %s" or "Editing secret project"),
      file_explorer_text = "" .. (discord_presence_mode == "home" and "Browsing %s" or "Browsing secret file"),
      git_commit_text = "" .. (discord_presence_mode == "home" and "Committing changes" or ""),
      plugin_manager_text = "" .. (discord_presence_mode == "home" and "Managing plugins" or ""),
      reading_text = "" .. (discord_presence_mode == "home" and "Reading %s" or ":blobawesome:"),
      workspace_text = "" .. (discord_presence_mode == "home" and "Working on %s" or "Working on secret project"),
      line_number_text = "" .. (discord_presence_mode == "home" and "Line %s out of %s" or ":blobsad:"),
    }
  }
}
