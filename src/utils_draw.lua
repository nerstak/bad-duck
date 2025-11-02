function draw_text_with_borders(txt, text_x, text_y, color_text, color_bg, color_border)
    local text_width = print(txt, text_x, text_y, color_text) - text_x + 3
    rrectfill(text_x - 2, text_y - 3, text_width, 11, 2, color_bg)
    rrect(text_x - 2, text_y - 3, text_width, 11, 2, color_border)
    print(txt, text_x, text_y, color_text)
end