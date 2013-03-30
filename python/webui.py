from piui import PiUi
 
ui = PiUi()
page = ui.new_ui_page(title="Hello")
title = page.add_textbox("Hello, world!")