#!/usr/bin/python
'''
Usage: tvex2vex.py [-I<includePath>] vexfile.tvex [<output.vex>]

Generates a new file 'vexfile.vex' from the template 'vexfile.tvex'
by expanding "*include <filename>" or "#include <filename>" directives
in the template. After this expansion pass, the generated output is checked
for any "*loaddata <datafile>" directives and VEX data fields are populated
or replaced using data from the referenced data files.

The format of a $CLOCK-populating data file is
   line 1: CLOCK
   line 2: <stationName> <ref_time for delay> <delay> <ref_time for rate> <rate>
   line 3: <stationName> <ref_time for delay> <delay> <ref_time for rate> <rate>
   ...
Other formats are not added yet.

(C) 2019 Jan Wagner, Max Planck Institute for Radio Astronomy
'''

import os, re, sys
import datetime
from optparse import OptionParser

__author__="Jan Wagner <jwagner@mpifr-bonn.mpg.de>"
__prog__ = os.path.basename(__file__)
__build__= "$Revision: 8798 $"
__date__ ="$Date: 2019-03-13 09:20:08 +0100 (Wed, 13 Mar 2019) $"
__lastAuthor__="$Author: JanWagner $"


def vextime2Datetime(s):
	return datetime.datetime.strptime(s, '%Yy%jd%Hh%Mm%Ss')


def datetime2Vextime(d):
	return d.strftime('%Yy%jd%Hh%Mm%Ss')


def loadFileLines(filename):
    lines = []
    try:
        with open(filename, 'r') as f:
            lines = f.readlines()
    except:
        pass
    return lines


def storeFileLines(filename, lines):
    with open(filename, 'w') as f:
        f.writelines(lines)


def findIncludeFile(filename, includepaths):
    '''
    Try to locate filename under all includepaths.
    Return full file&path, or None if not found.
    '''
    for inc in includepaths:
       fqpn = '%s/%s' % (inc,filename)
       if os.path.isfile(fqpn):
           return fqpn
    return None


def isComment(line):
    '''
    :return True if line is a comment or empty
    '''
    L = line.strip()
    return ( (len(L) < 1) or (L[0] == '*') or (L[0] == '#'))


def extractExperimentDetails(lines):
    '''
    Looks through VEX file lines in the in lines[] string,
    determines experiment name and start/stop times.
    :return (name:str, start:datetime, stop:datetime)
    '''
    name = None
    tstart = None
    tstop = None
    reName = re.compile( r'[\s]*exper_name[\s]*=[\s]*([\w\d]+)[\s]*;' )
    reStart = re.compile( r'[\s]*exper_nominal_start[\s]*=[\s]*([\w\d]+)[\s]*;' )
    reStop = re.compile( r'[\s]*exper_nominal_stop[\s]*=[\s]*([\w\d]+)[\s]*;' )
    for line in lines:
        if 'exper_name' in line:
            r = reName.search(line)
            name = r.group(1)
        elif 'exper_nominal_start' in line:
            r = reStart.search(line)
            tstart = vextime2Datetime(r.group(1))
        elif 'exper_nominal_stop' in line:
            r = reStop.search(line)
            tstop = vextime2Datetime(r.group(1))
        if name and tstart and tstop:
            break

    if not name:
        name = '<undefined>'
    if not tstop:
        tstop = datetime.datetime.utcnow()
    if not tstart:
        tstart = tstop
    return (name, tstart, tstop)


def expandIncludes(lines, includepaths):
    '''
    Go through list of 'lines' and expand all '*include<>' or '#include<>' statements.
    '''
    expanded = []

    # Regexp for '*include<>' with arbitrary preceding '*#' and whitespace:
    # test: sline='***  include  < testfile> '; g=reInclude.search(sline); print(g.groups())
    reInclude = re.compile( r'[#*]+\s*include\s*[<]+\s*(.*)\s*[>]+' )

    # Copy all lines, expand any includes
    for line in lines:

        if not isComment(line):
            expanded.append(line[:])
            continue

        sline = line.strip()
        incStatement = reInclude.search(sline)
        if incStatement:
            filename = incStatement.group(1)
            incfile = findIncludeFile(filename, includepaths)
            if incfile == None:
                print ('Error: could not find included file %s!' % (filename))
                print ('Statement: %s' % (sline))
                print ('Include paths: %s' % (str(includepaths)))
                sys.exit(1)
            if options.verbose:
                print ('Expanding on "%s" using "%s"' % (sline,incfile))
            insertable = loadFileLines(incfile)
            expanded += insertable
        else:
            expanded.append(line[:])

    return expanded


def populateData_Clock(vexlines, data):
    '''
    Update VEX entries with CLOCK data
    Todo: make the search for clock_early in VEX less picky, currently
          must be either a one-liner def ... enddef,
          or three-liner with no comment lines.
    '''

    reDef = re.compile( r'^[\s]*def[\s]+([\w\d]+)[\s]*;' )
    # Regex to match VEX clock_early
    # Match groups are  1:lhs leftover string, 2:dly_epoch, 3:dly_value, 4:dly_unit, 5:rate_epoch, 6:rate_value, 7:rhs leftover string/comments
    # ToDo: detect optional rate unit?
    reClkEarly = re.compile( r'(.*)[\s]*clock_early[\s]*=[\s]*([\w\d]+)[\s]*:[\s]*([+-.e\d]+)[\s]*([\w]+)[\s]*:[\s]*([\w\d]+)[\s]*:[\s]*([+-.e\d]+)[\s;]+(.*)' )

    # Load data
    clks = []
    ants = []
    for d in data:
        d = d.strip()
        if isComment(d):
            continue
        items = d.split() # todo: try/except?
        if len(items) == 2:
            (antenna,delay) = items
            rate = None
        elif len(items) == 3:
            (antenna,delay,rate) = items
        else:
            print("Error parsing clock file line with: '%s'" % (d))
            continue
        clk = {'antenna':antenna, 'delay':delay, 'rate':rate}
        clks.append(clk)
        ants.append(antenna)
		# TODO: add a 'valid starting from' column to support in-track clock breaks?

    # Read experiment time range to selectively update clock_early'ies matching just this experiment
    (expname,vex_tstart,vex_tstop) = extractExperimentDetails(vexlines)

    # Update VEX
    currAnt = None
    for n in range(1,len(vexlines)):

        line = vexlines[n]
        if isComment(line):
            continue

        # Remember recent 'def <something>;' regardless of block type (CLOCK, ANTENNA, ...)
        if ('def ' in line):
            r = reDef.search(line.strip())
            if r:
                currAnt = r.group(1)
            else:
                continue

        # Skip any clock_early entries not belonging to an updateable antenna
        if 'clock_early' not in line:
            continue
        if currAnt and (currAnt not in ants):
            if options.verbose:
                print ('Skip: antenna %s not among updateable antennas in data file' % (currAnt))
            currAnt = None
            continue
        if not currAnt:
            continue

        # Parse clock_early and update it
        r = reClkEarly.search(line)
        if not r:
            continue
        vexclk = {
            "lhs":r.group(1),
            "delayEpoch":r.group(2), "delay":r.group(3), "delayUnit":r.group(4),
            "rateEpoch":r.group(5), "rate":r.group(6),
            "rhs":r.group(7)
        }
        vexepoch = vextime2Datetime(vexclk['delayEpoch'])

        if vexepoch >= vex_tstop:
            if options.verbose:
                print("Skip: " + currAnt + " VEX clock_early at %s (%s) is VEX experiment start/stop range of %s to %s" % (vexclk['delayEpoch'],str(vexepoch),str(vex_tstart),str(vex_tstop)))
            continue

        usrclk = clks[ants.index(currAnt)]
        if (currAnt != usrclk['antenna']):
            print("Programmer oops in populateData_Clock(): antenna list index didn't match tuple index of antenna")
            sys.exit(1)

        if usrclk['rate'] is None:
            usrclk['rate'] = vexclk['rate']
            if options.verbose:
                print('Antenna %s: retaining existing VEX clock_early rate of %s' % (currAnt, vexclk['rate']))

        # Replace with new clock line
        newClk = '%sclock_early = %s : %s %s : %s : %s;%s\n' % (vexclk['lhs'], vexclk['delayEpoch'], usrclk['delay'], vexclk['delayUnit'], vexclk['rateEpoch'], vexclk['rate'], vexclk['rhs'])
        vexlines[n] = newClk

    return vexlines


def populateData(lines, includepaths):
    '''
    Go through list of 'lines' and look for '*loaddata<>' statements,
    invoke the respective data loader according to data type
    specified in the file.
    '''
    updated = []
    supported_datatypes = ['CLOCK']

    # Regexp for '*loaddata<>' with arbitrary preceding '*#' and whitespace:
    reLoad = re.compile( r'[#*]+\s*loaddata\s*[<]+\s*(.*)\s*[>]+' )

    # Check all lines, find all loaddata directives, remove them
    loadFiles = []
    for line in lines:
        loadStatement = reLoad.search(line)
        if loadStatement:
            datafile = loadStatement.group(1)
            incfile = findIncludeFile(datafile, includepaths)
            if incfile == None:
                print ('Error: could not find included file %s!' % (datafile))
                print ('Statement: %s' % (line))
                print ('Include paths: %s' % (str(includepaths)))
                sys.exit(1)
            loadFiles.append(incfile)
            if options.verbose:
                print ('Updating upon "%s" using "%s"' % (line.strip(),incfile))
        else:
            updated.append(line[:])

    # Process the loaddata files
    for file in loadFiles:

        # print ('Loading %s' % (file))
        data = []
        with open(file, 'r') as df:
            data = df.readlines()

        if len(data) < 2:
            print ('Bad data file %s: too short' % (file))
            sys.exit(1)

        datatype = data[0].strip()
        data = data[1:]

        supported = datatype in supported_datatypes
        if not supported:
            print ('Bad data file %s: unsupported type %s' % (file,datatype))
            sys.exit(1)

        if datatype == 'CLOCK':
            updated = populateData_Clock(updated, data)

    return updated


def generateVex(tvexfile, includepaths, vexname=None):
    '''
    Load and parse template vex file.
    '''

    # Load and process
    tvex = loadFileLines(tvexfile)
    if len(tvex) < 1:
        print('No data in %s' % (tvexfile))
        sys.exit(1)
    vex = expandIncludes(tvex, options.includepaths)
    vex = populateData(vex, options.includepaths)

    # Output to console or to file
    if (vexname == None):
        for line in vex:
            print(line.rstrip())
    else:
        storeFileLines(vexname, vex)
        print ('Wrote results into %s' % (vexname))


if __name__ == "__main__":

    parser = OptionParser(version=__build__, usage=__doc__)
    parser.add_option('-v', '--verbose', dest='verbose', action='store_true')
    parser.add_option('-I', '--include', dest='includepaths', action='append', type='str')
    (options, args) = parser.parse_args()

    if len(args) < 1:
        print(__doc__)
        sys.exit(0)

    tvexfile = args[0]
    vexoutname = None
    if len(args) > 1:
        vexoutname = args[1]

    vex = generateVex(tvexfile, options.includepaths, vexoutname)
