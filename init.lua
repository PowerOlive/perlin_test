local mapseed

minetest.register_on_mapgen_init(function(mgparams)
	if mgparams.mgname ~= "singlenode" then
		minetest.set_mapgen_params({mgname="singlenode"})
	end
	mapseed = minetest.get_mapgen_params().seed
end)

minetest.register_on_generated(function(minp, maxp, blockseed)

	local perlin = minetest.get_perlin(mapseed, 3, 0.5, 50)

	local vm, emin, emax = minetest.get_mapgen_object("voxelmanip")
	local va = VoxelArea:new{MinEdge=emin, MaxEdge=emax}
	local data = vm:get_data()

	local c_air = minetest.get_content_id("air")
	local c_ground = minetest.get_content_id("default:stone")

	for zz=minp.z, maxp.z do
	for xx=minp.x, maxp.x do

		local val = math.floor(perlin:get2d({x=xx, y=zz}) * 10)

		for yy=minp.y, maxp.y do

			local i = va:index(xx,yy,zz)
			if yy == val then
				data[i] = c_ground
			else
				data[i] = c_air
			end

		end

	end
	end

	vm:set_data(data)
	vm:set_lighting({day=0, night=0})
	vm:calc_lighting()
	vm:write_to_map(data)
end)
