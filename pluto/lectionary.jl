### A Pluto.jl notebook ###
# v0.19.41

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ 6553c67d-8ff2-42ec-b941-abe980c03adf
begin
	using Pkg
	
	tmpproject = tempdir()
	Pkg.add(path=dirname(pwd()))
	Pkg.activate(tmpproject)
	
	using Lectionary
	Pkg.add("Dates")
	using Dates

	Pkg.add("PlutoUI")
	using PlutoUI
end


# ╔═╡ a7df3773-bf7a-40e8-9010-2e0416e6db7f
TableOfContents()

# ╔═╡ 46fd1ec0-b320-48b4-8657-f9776153044e
md"""*See information about the Julia environment*: $(@bind envdata CheckBox())"""

# ╔═╡ 27403e93-056b-4df2-a626-3e1dcff2b9f9
if envdata
	md"""

>Unhide the cell before this one to see how the project environment is built.
>
>The notebook uses a temporary directory that you can remove when you're through with this session. It's at this location in your local file system:
>
>
#### $(tmpproject)
"""
end

# ╔═╡ 043e8bc6-fd69-11ee-2fc2-13e3ef6f2f45
md"""# Calendar of liturgical year"""

# ╔═╡ cce258f0-7d4e-400c-9e37-e4f8db07c419
html"""
<style>
	.hilitedate {
		background-color: coral;
		border-radius: 20px;
		font-weight: bold;
	}
</style>
"""

# ╔═╡ 739b3152-e3da-40f2-82ee-581a7bc016d7
html"""

<br/><br/><br/><br/>
<br/><br/><br/><br/>
<br/><br/><br/><br/>

"""

# ╔═╡ 8defff25-72da-45f8-98c0-b0289fb40929
md"""> # Under the hood"""

# ╔═╡ 69d3ee51-6cb1-4eb3-981a-4f0da4475988
md"""> ## Building calendar
>
> Organize 7-element Vectors ordered from Sunday to Saturday with values for days of the month.
"""

# ╔═╡ 5315829b-d9ea-4116-85a6-bcb7a6988928
date_today = Dates.now() |> Date

# ╔═╡ 0583ad70-b693-4fc8-b553-c70d42ccb632
md"""*Choose a year and month*: $(@bind yr  NumberField(2000:2050, default=year(date_today))) $(@bind mo Select([
	0 => "",
	1 => "January",
	2 => "February",
	3 => "March",
	4 => "April",
	5 => "May",
	6 => "June",
	7 => "July",
	8 => "August",
	9 => "September",
	10 => "October",
	11 => "November",
	12 => "December"
]))  """

# ╔═╡ 5a1e04c5-20d6-4f0b-9207-80d8368b7670
if mo > 0
	md"""*Choose a day*: $(@bind dayofmonth NumberField(1:daysincalmonth(yr, mo)))"""
end
	

# ╔═╡ da7b2eb5-4075-479d-8eb9-e66aa6d4c378
if mo > 0
	selected_date = Dates.Date(yr, mo)
	md"""### Calendar for  $(monthname(selected_date)), $(year(selected_date))
"""
end

# ╔═╡ f4ccc2ac-2cdd-4922-ab65-f635ca7fce8d
dayslots = Dict(
	"Sunday" => 1,
	"Monday" => 2,
	"Tuesday" => 3, 
	"Wednesday" => 4,
	"Thursday" => 5,
	"Friday" => 6,
	"Saturday" => 7
)

# ╔═╡ 177966ac-7b0e-4317-bf6c-859e3b9baef4
"""Starting from the requested year, month, and day, get a 7-day list of date values  ordered from Sunday -> Saturday.  Days not inlcuded have a value of 0."""
function weekvector(yr,mo,daynum)
	rowvals =  [0,0,0,0,0,0,0]
	try 
		dayone = Dates.Date(yr,mo,daynum) 
		lastday = Dates.Date(yr, mo + 1, 1)  - Dates.Day(1)
		currday = dayone
		done = false

		while currday <= lastday && ! done 
			idx = dayslots[dayname(currday)]
			rowvals[idx] = calday(currday)
			#@debug("Date $(currday) is $(dayname(currday))")
			currday = currday + Dates.Day(1)
			if dayname(currday) == "Sunday"
				done = true
			end
		end
	
	catch e
		# Need a more graceful way to found out if day is out of range for month...
		#@debug("something went wrong: $(e)")
	end
	
	rowvals
end

# ╔═╡ 30e765d6-81a1-41db-b9e9-dc9c62b3d0f3
"""True if week record is all 0s."""
function emptyweek(wk)
	wk == [0,0,0,0,0,0,0]
end

# ╔═╡ 1c179f98-150c-4a89-a361-33ef064d683a
weekvector(2024,4,1) 

# ╔═╡ 6495c3fa-e319-4bfa-8086-d6d8c2d25b2a
"""Find last non-zero value in vector."""
function lastnonzero(v)
	valuelist = filter(item -> item != 0, v)
	isempty(valuelist) ? 0 : valuelist[end]
end

# ╔═╡ 7e09b4f6-6c0c-4bcb-96b5-712c0ab11d0d
lastnonzero([0,0,1,2])

# ╔═╡ d7c54db0-f615-4772-a056-f9b7a5e3886a
"""For requested year and month, get one month's worth of week vectors."""
function monthvectors(yr,mo)
	currdaynum = 1
	curr_row = weekvector(yr,mo,currdaynum)
	all_rows = [curr_row]
	maxiters = 7
	iters = 1
	while ! emptyweek(curr_row) && currdaynum < 32 #&& iters < maxiters
		iters = iters + 1
		
		
		#currdaynum = curr_row[end] + 1
		currdaynum = lastnonzero(curr_row) + 1
		#@debug("$(iters). Currdaynum $(currdaynum)")
		curr_row = weekvector(yr,mo,currdaynum)
		if ! emptyweek(curr_row)
			#@debug("Found empty week!")
			push!(all_rows, curr_row)
		end
	end
	all_rows

end

# ╔═╡ addd39f3-5daa-4db7-8f27-69a9f010fcca
monthvectors(2024,4)

# ╔═╡ 2ecc6327-136d-4e6b-8372-921934ddf4cb
md"""> ## HTML formatting"""

# ╔═╡ 06f241fe-a31d-4e75-8ecb-073fee06c919
userdate = if mo > 0
	Dates.Date(yr, mo, dayofmonth)
else
	nothing
end

# ╔═╡ e64c6bf2-b478-47ba-b1df-26c31654bc88
"""Format a week of dates as a row of an HTML table."""
function formatrow(r)
	days = map(r) do num


		
		
		if num == 0 
			"<td/>" 
		else
			calfornum = Dates.Date(yr, mo, num)
			if calfornum == userdate
				"""<td class="hilitedate">$(num)</td>"""
			else
				"<td>$(num)</td>"
			end
		end
	end
	string("<tr>", join(days), "</tr>")
end

# ╔═╡ 1bf12c03-1fbb-4e6e-b6d4-32fe1a2454d8
calheader = """
<thead>
            <tr>
                <th>Sun</th>
                <th>Mon</th>
                <th>Tue</th>
                <th>Wed</th>
                <th>Thu</th>
                <th>Fri</th>
                <th>Sat</th>
            </tr>
        </thead>
"""

# ╔═╡ ea75bfa2-1d47-4d4b-9aa7-1543491b7f9d
"""Format an HTML calendar for one month."""
function month_html(yr,mo)
	weeks = monthvectors(yr,mo) .|> formatrow
	
	str = """<table>
	
        $(calheader)
	<tbody>
	$(join(weeks,"\n"))
	</tbody>
</table>	
"""	
end

# ╔═╡ ecf8a3ff-aaa8-4e73-ac85-be6b8fc0e461
mo > 0 ?  month_html(yr,mo) |> HTML : nothing

# ╔═╡ Cell order:
# ╟─6553c67d-8ff2-42ec-b941-abe980c03adf
# ╟─a7df3773-bf7a-40e8-9010-2e0416e6db7f
# ╟─46fd1ec0-b320-48b4-8657-f9776153044e
# ╟─27403e93-056b-4df2-a626-3e1dcff2b9f9
# ╟─043e8bc6-fd69-11ee-2fc2-13e3ef6f2f45
# ╟─0583ad70-b693-4fc8-b553-c70d42ccb632
# ╟─da7b2eb5-4075-479d-8eb9-e66aa6d4c378
# ╟─5a1e04c5-20d6-4f0b-9207-80d8368b7670
# ╟─ecf8a3ff-aaa8-4e73-ac85-be6b8fc0e461
# ╟─e64c6bf2-b478-47ba-b1df-26c31654bc88
# ╠═cce258f0-7d4e-400c-9e37-e4f8db07c419
# ╟─739b3152-e3da-40f2-82ee-581a7bc016d7
# ╟─8defff25-72da-45f8-98c0-b0289fb40929
# ╟─69d3ee51-6cb1-4eb3-981a-4f0da4475988
# ╟─5315829b-d9ea-4116-85a6-bcb7a6988928
# ╟─f4ccc2ac-2cdd-4922-ab65-f635ca7fce8d
# ╟─177966ac-7b0e-4317-bf6c-859e3b9baef4
# ╟─30e765d6-81a1-41db-b9e9-dc9c62b3d0f3
# ╠═1c179f98-150c-4a89-a361-33ef064d683a
# ╟─6495c3fa-e319-4bfa-8086-d6d8c2d25b2a
# ╠═7e09b4f6-6c0c-4bcb-96b5-712c0ab11d0d
# ╟─d7c54db0-f615-4772-a056-f9b7a5e3886a
# ╠═addd39f3-5daa-4db7-8f27-69a9f010fcca
# ╟─2ecc6327-136d-4e6b-8372-921934ddf4cb
# ╟─06f241fe-a31d-4e75-8ecb-073fee06c919
# ╟─ea75bfa2-1d47-4d4b-9aa7-1543491b7f9d
# ╟─1bf12c03-1fbb-4e6e-b6d4-32fe1a2454d8
