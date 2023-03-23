from PIL import Image

# PNG画像のファイルパス
file_path = "sokoban_tilesheet.png"

# タイルのサイズ
tile_size = 64

def cut_tiled_image(tile_coordinates, tile_width, tile_height, out_file_name):
    # オリジナルの画像を開く
    original_image = Image.open(file_path)

    # キャンバス作成
    canvas_size_width = tile_width * tile_size
    canvas_size_height = tile_height * tile_size
    new_canvas = Image.new("RGBA", (canvas_size_width, canvas_size_height), (0, 0, 0, 0))

    # タイルを切り取る
    for i, (tile_x, tile_y) in enumerate(tile_coordinates):
        x = (i % tile_width) * tile_size
        y = (i // tile_width) * tile_size
        tile = original_image.crop((tile_x * tile_size, tile_y * tile_size, (tile_x + 1) * tile_size, (tile_y + 1) * tile_size))
        new_canvas.paste(tile, (x, y))

    # 切り取ったタイルを保存する
    new_canvas.save(out_file_name)


"""playerタイル"""
# 切り取りたいタイルの位置
tile_coordinates = [(0, 4), (1, 4), (2, 4), (3, 4), (4, 4), (5, 4)
                    ,(0, 6), (1, 6), (2, 6), (3, 6), (4, 6), (5, 6)]
# できあがりのタイルのサイズ
width = 3
height = 4
# 保存するファイル名
out_file_name = "player.png"
cut_tiled_image(tile_coordinates, width, height, out_file_name)

"""crateタイル"""
# 切り取りたいタイルの位置
tile_coordinates = [(6, 0), (7, 0), (8, 0), (9, 0), (10, 0)]
# できあがりのタイルのサイズ
width = 1
height = 5
# 保存するファイル名
out_file_name = "crate.png"
cut_tiled_image(tile_coordinates, width, height, out_file_name)

"""blockタイル"""
# 切り取りたいタイルの位置
tile_coordinates = [(6, 6), (7, 6), (8, 6), (9, 6)]
# できあがりのタイルのサイズ
width = 1
height = 4
# 保存するファイル名
out_file_name = "block.png"
cut_tiled_image(tile_coordinates, width, height, out_file_name)

"""groundタイル"""
# 切り取りたいタイルの位置
tile_coordinates = [(10, 6), (11, 6), (12, 6)]
# できあがりのタイルのサイズ
width = 1
height = 3
# 保存するファイル名
out_file_name = "ground.png"
cut_tiled_image(tile_coordinates, width, height, out_file_name)

"""pointタイル"""
# 切り取りたいタイルの位置
tile_coordinates = [(12, 1), (12, 2), (12, 3), (12, 4), (12, 5)]
# できあがりのタイルのサイズ
width = 1
height = 5
# 保存するファイル名
out_file_name = "point.png"
cut_tiled_image(tile_coordinates, width, height, out_file_name)

