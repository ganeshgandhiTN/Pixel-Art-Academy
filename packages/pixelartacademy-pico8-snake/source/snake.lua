cls()
color(10)
rectfill(0,0,128,128)
color(0)
print("snake",54,50)
print("press button to start",22,70)
waittostart=true

function _init()
	timetomove=5
	timeleft=timetomove
	snake={{4,8},{5,8}}
	head=2
	tail=1
	movex=1
	movey=0
	eatingleft=0
	score=0
	newfood()
end

function newfood()
	foodx=flr(rnd(15))+1
	foody=flr(rnd(15))+1
end

function wait()
	if (btnp(4) or btnp(5)) then
		waittostart=false
		_init()
	end
end

function movesnake()

	--update snake
	timeleft-=1
	if timeleft==0 then
		timeleft=timetomove

		--move snake by adding new piece
		snake[head+1]={}
		snake[head+1][1]=snake[head][1]+movex
		snake[head+1][2]=snake[head][2]+movey
		head+=1

		--check if head is eating
		if ((snake[head][1]==foodx) and (snake[head][2]==foody)) then
			newfood()
			eatingleft=1
			score+=1
		end

		--check if head is out of bounds
		if ((snake[head][1]<0) or (snake[head][1]>15) or (snake[head][2]<0) or (snake[head][2]>15)) then
			die()
		end

		--check if head is in other part
		for i=tail,(head-1) do
			if ((snake[i][1]==snake[head][1]) and (snake[i][2]==snake[head][2])) then
				die()
			end
		end

		if eatingleft>0 then
			eatingleft-=1
		else
			tail+=1
		end
	end
end

function die()
 dead=true
	waittostart=true
	if dead then
		print("score:",50,50)
		print(score,75,50)
		print("press button to start",22,70)
	end
end

function changedirection()
	if btn(0) then
		movex=-1
		movey=0
	end
	if btn(1) then
		movex=1
		movey=0
	end
	if btn(2) then
		movex=0
		movey=-1
	end
	if btn(3) then
		movex=0
		movey=1
	end
end

function _update()
	if (waittostart) then
		wait()
	else
		movesnake()
		changedirection()
	end
end

function _draw()
	if (waittostart) return

	--clear
	rectfill(0,0,128,128,10)
	color(0)

	--draw snake
	for i=tail,head do
		x=snake[i][1]*8
		y=snake[i][2]*8
		spr(0,x,y)
	end

	--draw food
	spr(1,foodx*8,foody*8)
end
