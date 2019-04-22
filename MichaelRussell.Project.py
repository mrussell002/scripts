# Programmer:	Michael Russell
# Course:		ITSE 1359 001
# Instructor:	Seitsinger
# Assignment:	Final Project

import os
import shutil
from tkinter import *

# This class will verify the source and destination directories before the copy process.
# After verification, the files are copied and a log is kept and displayed.
class CopyFiles:

	def __init__(self):
		# Get the source and destination information
		sDir=srcTextBox.get()
		dDir=destTextBox.get()
		self.__verifySource__(sDir)
		self.__verifyDest__(dDir)
		self.__verifyPath__(sDir,dDir)
		
	def __verifySource__(self,sDir):
		# Verify something is in the source textbox. If not display a message
		if (sDir==""):
			win=Toplevel()
			Label(win, text="You must specify a source directory.").pack()
			Button(win, text="Close", command=win.destroy).pack()
			if popupper():
				win.focus_set()
				win.grab_set()
				win.wait_window()

	def __verifyDest__(self,dDir):
		# Verify something is in the destination textbox. If not display a message
		if (dDir==""):
			win=Toplevel()
			Label(win, text="You must specify a destination directory.").pack()
			Button(win, text="Close", command=win.destroy).pack()
			if popupper():
				win.focus_set()
				win.grab_set()
				win.wait_window()

	def __verifyPath__(self,sDir,dDir):
		# Verify and get the source directory
		if (os.path.isdir(sDir)):
			s=os.listdir(sDir)
		
		# If the source does not exist, let the user know
		else:
			win=Toplevel()
			Label(win, text="The source directory does not exit.").pack()
			Button(win, text="Close", command=win.destroy).pack()
			if popupper():
				win.focus_set()
				win.grab_set()
				win.wait_window()

		# Verify and get the destination directory
		if (os.path.isdir(dDir)):
			d=os.listdir(dDir)

			# Open the log.txt file for writing
			logPath=dDir + "\log.txt"
			log=open(logPath, "w")

			# Copy the files if we have a good source and destination
			for f in s:
				fromPath=os.path.join(sDir, f)
				toPath=os.path.join(dDir, f)
				if (os.path.isfile(fromPath)):
					shutil.copy(fromPath, toPath)
					output=f + '\n'
					log.write(output)
					# Change the text in the displayLabel
					var.set("File copied:  " + output)

		# If the destination does not exist, tell the user it doesn't exist and create the directory
		else:
			win=Toplevel()
			Label(win, text="The destination directory does not exist, we will create it.").pack()
			Button(win, text="Close", command=win.destroy).pack()
			#if popupper():
			win.focus_set()
			win.grab_set()
			win.wait_window()

			# Create the directory
			os.makedirs(dDir)

			# Open the log.txt file for writing
			logPath=dDir + "\log.txt"
			log=open(logPath, "w")

			# Copy the files now that we have a good source and destination
			for f in s:
				fromPath=os.path.join(sDir, f)
				toPath=os.path.join(dDir, f)
				if (os.path.isfile(fromPath)):
					shutil.copy(fromPath, toPath)
					log.write(f + '\n')
					output=f + '\n'
					# Change the text in the displayLabel
					var.set("copied:  " + output)

	def __close__(self,log):
		# Close the log file
		log.close()
		del log

# Main program
root=Tk()

# Set the initial output display text
var=StringVar()
var.set('Preparing to copy files...')

# create the frame and grid
frame=Frame(root)
frame.grid()

# create a title
root.title("File Copy...")

# create an empty row
rowSpace1=Label(frame, text="")
rowSpace1.grid(row=0, column=0, columnspan=12, pady=5)

# create an empty column
spaceLabel1=Label(frame, text="")
spaceLabel1.grid(row=1, column=0, pady=5)

# create the "source" label
sourceLabel=Label(frame, text="Source", width=15, justify=RIGHT)
sourceLabel.grid(row=1, column=1, pady=5)

# create the "source" textbox
srcTextBox=Entry(frame, width=30)
srcTextBox.grid(row=1, column=9, columnspan=5, pady=5)

# create an empty row
rowSpace2=Label(frame, text="")
rowSpace2.grid(row=2, column=0, columnspan=12, pady=5)

# create an empty space
spaceLabel3=Label(frame, text="")
spaceLabel3.grid(row=3, column=0, pady=5)

# create the "destination" label
destinationLabel=Label(frame, text="Destination", width=15, justify=RIGHT)
destinationLabel.grid(row=3, column=1, pady=5)

# create the "destination" textbox
destTextBox=Entry(frame, width=30)
destTextBox.grid(row=3, column=9, columnspan=5, pady=5)

# create an empty space
rowSpace3=Label(frame, text="")
rowSpace3.grid(row=4, column=0, pady=5)

# create the notification area
displayLabel=Message(frame, textvariable=var, width=1000, justify=LEFT, relief=RAISED)
displayLabel.grid(row=5, column=1, rowspan=10, columnspan=10, pady=5, )

# creating more empty spaces
spaceLabel4=Label(frame, text="")
spaceLabel4.grid(row=7, column=11, padx=5)

# create the "copy" button
copyButton=Button(frame, text="Copy", command=CopyFiles)
copyButton.grid(row=7, column=12, pady=5)

# creating more empty space
spaceLabel5=Label(frame, text="")
spaceLabel5.grid(row=11, column=11, padx=5)

# create the "exit" button
exitButton=Button(frame, text="Exit", command=sys.exit)
exitButton.grid(row=11, column=12, pady=5)

# creating more empty space
columnSpaceLabel=Label(frame, text="")
columnSpaceLabel.grid(row=0, column=15, pady=5)

root.mainloop()
