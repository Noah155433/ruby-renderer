require './src/triangle_data.rb'
require './src/rasterizer.rb'

class Obj
    def initialize(filepath)
        
        v_count = 0
        f_count = 0

        @v = Array.new
        @f = Array.new

        File.readlines(filepath, chomp: true).each do |line|
            line = line.split(" ")
            if line[0] == "v" && line[0].length == 1
                line.shift
                for i in 0..2
                    line[i] = line[i].to_f
                end
                @v[v_count] = line
                v_count += 1
            end
            if line[0] == "f" && line[0].length == 1
                line.shift
                @f[f_count] = line
                f_count += 1
            end
        end
    end

    def draw(maps)
        for i in @f
            indices = Array.new(4)
            for j in 0..2
                indices[j] = i[j].split("/")[0]
                indices[j] = indices[j].to_i - 1
            end

            tri_data1 = Tri_data.new(@v[indices[0]], @v[indices[1]], @v[indices[2]])
            
            Rasterizer.draw_tri(tri_data1, maps, 512, 512)
            
            if i.length == 4
                indice_order = [1, 3, 4]
                for j in 0..2
                    indices[j] = i[indice_order[j] - 1].split("/")[0]
                    indices[j] = indices[j].to_i - 1
                end
                tri_data2 = Tri_data.new(@v[indices[0]], @v[indices[1]], @v[indices[2]])
                Rasterizer.draw_tri(tri_data2, maps, 512, 512)
            end
            

        end
    end

end