#
#  ThurkController.rb
#  blergh
#
#  Created by ARS Film on 5/19/11.
#  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
#

require 'osx/cocoa'

class ThurkController < OSX::NSObject

	include OSX
	  

  	ib_outlet :textthurk
  	ib_outlet :frames
	ib_outlet :pset
	
	ib_action :thurkme
	
	def awakeFromNib
		framerates = ["30","29.97","25","24","15","12","8","60","50"]
		@frames.removeAllItems
		@frames.addItemsWithTitles(framerates)
		@frames.selectItemWithTitle(framerates[0])
		phonemesetlist = ["Preston Blair","Preston Blair Sad","Simplified Flash","PowerHouse Happy","PowerHouse Sad", "Full Set"]
		@pset.removeAllItems
		@pset.addItemsWithTitles(phonemesetlist)
		@pset.selectItemWithTitle(phonemesetlist[0])
		end
		
	

			
	def thurkme(sender)
	
	case@frames.selectedItem.title.to_s
		when '30'; @@fps = "\tUnits Per Second\t30"
		when '29.97'; @@fps = "\tUnits Per Second\t29.97"
		when '25'; @@fps = "\tUnits Per Second\t25"
		when '24'; @@fps = "\tUnits Per Second\t24"
		when '15'; @@fps = "\tUnits Per Second\t15"
		when '12'; @@fps = "\tUnits Per Second\t12"
		when '8'; @@fps = "\tUnits Per Second\t8"
		when '60'; @@fps = "\tUnits Per Second\t60"
		when '50'; @@fps = "\tUnits Per Second\t50"
	end	
	puts(@@fps)
	
	case@pset.selectedItem.title.to_s
		when 'Preston Blair'; @@mapping = {
    "AI" => 1.001,
    "E" => 2.001,
    "L" => 3.001,
    "FV" => 4.001,
    "MBP" => 5.001,
    "O" => 6.001,
    "U" => 7.001,
    "WQ" => 8.001,
    "etc" => 9.001,
    "rest" => 0.001, 
	"TH" => 9.001,
	"CH"  => 9.001  
	}
		
		when 'Preston Blair Sad'; @@mapping = {
    "AI" => 11.001,
    "E" => 12.001,
    "L" => 13.001,
    "FV" => 14.001,
    "MBP" => 15.001,
    "O" => 16.001,
    "U" => 17.001,
    "WQ" => 18.001,
    "etc" => 19.001,
    "rest" => 10.001, 
	"TH" => 19.001,
	"CH"  => 19.001 }

		when 'Simplified Flash';@@mapping = {
	"AI" => 2.001,
    "E" => 3.001,
    "L" => 6.001,
    "FV" => 7.001,
    "MBP" => 1.001,
    "O" => 5.001,
    "U" => 5.001,
    "WQ" => 5.001,
    "etc" => 4.001,
    "rest" => 0, 
	"TH" => 4.001,
	"CH"  => 4.001 
	}
		
		when 'PowerHouse Happy'; @@mapping = {
    "AI" => 3.001,
    "E" => 1.001,
    "L" => 7.001,
    "FV" => 6.001,
    "MBP" => 6.001,
    "O" => 4.001,
    "U" => 2.001,
    "WQ" => 5.001,
    "etc" => 1.001,
    "rest" => 0, 
	"TH" => 8.001,
	"CH"  => 9.001 
	}
		
		when 'PowerHouse Sad'; @@mapping = {
    "AI" => 13.001,
    "E" => 11.001,
    "L" => 17.001,
    "FV" => 16.001,
    "MBP" => 16.001,
    "O" => 14.001,
    "U" => 12.001,
    "WQ" => 15.001,
    "etc" => 11.001,
    "rest" => 10.001, 
	"TH" => 18.001,
	"CH"  => 19.001 
	}
	
		when 'Full Set'; @@mapping = {
    "AI" => 1.001,
    "E" => 2.001,
    "L" => 3.001,
    "FV" => 4.001,
    "MBP" => 5.001,
    "O" => 6.001,
    "U" => 7.001,
    "WQ" => 8.001,
    "etc" => 9.001,
    "rest" => 0, 
	"TH" => 10.001,
	"CH"  => 11.001 
	}
		
		end

	@@headertop =<<-eos
Adobe After Effects 8.0 Keyframe Data

eos
	@@fpsheader =<<-eos
eos

	@@headerbottom=<<-eos
	
\tSource Width\t1000
\tSource Height\t1000
\tSource Pixel Aspect Ratio\t1
\tComp Pixel Aspect Ratio\t1

Time Remap
\tFrame\tseconds
\t0\t0.001
eos
 
	@@footer = "\nEnd of Keyframe Data\n"
  	
		oPanel = NSOpenPanel.openPanel

		oPanel.setAllowsMultipleSelection(false)
		
		oPanel.title = "Choose a Papagayo Dat File" 
		
		oPanel.prompt = "Convert to AE"		
		
		buttonClicked = oPanel.runModalForTypes(['dat'])
		
			if buttonClicked == NSOKButton
			blob = oPanel.filenames
			puts blob.inspect
			@thurk= (blob[0])
			@textthurk.setStringValue('Conversion Done!')
		    f = File.open(@thurk, 'r')
			@input = f.read
			f.close
			@output = @@headertop<<@@fps<<@@fpsheader<<@@headerbottom
				@input.split(/\n/).each do |line|
				puts line
				m = /^(\d+)\s+(\w+)$/.match(line)
					if m
					trans = @@mapping[m[2]]
						if trans
						@output += "\t#{m[1]}\t#{trans}\n"
						end
					end
				end
			@output += @@footer
			m = /^(.+)\.\w+$/.match(File.basename(@thurk))
			new_file = m ? m[1] + ".txt" : File.basename(@thurk) + ".txt"
			File.open(File.join(File.dirname(@thurk), new_file), 'w'){|f| f.write(@output)}
			puts(@output)
			IO.popen('pbcopy', 'w'){|f| f.write(@output)}
		  	end
		end
	end
 