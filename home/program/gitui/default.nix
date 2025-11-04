{ colors, enable ? false, ... }:

{
  enable = enable;
  keyConfig = ''
    (
      open_help: Some(( code: F(1), modifiers: "")),
      move_left: Some(( code: Char('h'), modifiers: "")),
      move_right: Some(( code: Char('l'), modifiers: "")),
      move_up: Some(( code: Char('k'), modifiers: "")),
      move_down: Some(( code: Char('j'), modifiers: "")),
      popup_up: Some(( code: Char('p'), modifiers: "CONTROL")),
      popup_down: Some(( code: Char('n'), modifiers: "CONTROL")),
      page_up: Some(( code: Char('b'), modifiers: "CONTROL")),
      page_down: Some(( code: Char('f'), modifiers: "CONTROL")),
      home: Some(( code: Char('g'), modifiers: "")),
      end: Some(( code: Char('G'), modifiers: "SHIFT")),
      shift_up: Some(( code: Char('K'), modifiers: "SHIFT")),
      shift_down: Some(( code: Char('J'), modifiers: "SHIFT")),
      edit_file: Some(( code: Char('I'), modifiers: "SHIFT")),
      status_reset_item: Some(( code: Char('U'), modifiers: "SHIFT")),
      diff_reset_lines: Some(( code: Char('u'), modifiers: "")),
      diff_stage_lines: Some(( code: Char('s'), modifiers: "")),
      stashing_save: Some(( code: Char('w'), modifiers: "")),
      stashing_toggle_index: Some(( code: Char('m'), modifiers: "")),
      stash_open: Some(( code: Char('l'), modifiers: "")),
      abort_merge: Some(( code: Char('M'), modifiers: "SHIFT")),
    )
  '';
  theme = ''
    (
      selected_tab: Some("Reset"),
      selection_bg: Some("#${colors.base00}"),
      selection_fg: Some("#${colors.base0D}"),
      command_fg: Some("#${colors.base0D}"),
      cmdbar_bg: Some("#${colors.base00}"),
      cmdbar_extra_lines_bg: Some("#${colors.base00}"),
      disabled_fg: Some("#${colors.base04}"),
      diff_line_add: Some("#${colors.base0B}"),
      diff_line_delete: Some("#${colors.base08}"),
      diff_file_added: Some("#${colors.base0B}"),
      diff_file_removed: Some("#${colors.base08}"),
      diff_file_moved: Some("#${colors.base0E}"),
      diff_file_modified: Some("#${colors.base0A}"),
      commit_hash: Some("#${colors.base0E}"),
      commit_time: Some("#${colors.base0C}"),
      commit_author: Some("#${colors.base0B}"),
      danger_fg: Some("#${colors.base08}"),
      push_gauge_bg: Some("#${colors.base00}"),
      push_gauge_fg: Some("Reset"),
      tag_fg: Some("#${colors.base0E}"),
      branch_fg: Some("#${colors.base0A}"),
    )
  '';
}
