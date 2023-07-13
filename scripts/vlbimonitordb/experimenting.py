#!/usr/bin/python3
from __future__ import print_function
import requests
import datetime, calendar
from dbSession import dbSession

# JanW: some testing...

server = 'vlbimon1'
SERVER = 'https://%s.science.ru.nl' % server
FNAME = '.sessionid.%s.txt' % server
USER = 'Alan Roy'
PASSWD = 'Roy'

def get_session():
    '''Setup user session with server'''
    def restore_session(s):
        #-- read from file
        with open(FNAME, 'r') as f:
            sessionid = f.readline().strip()
        #-- validate
        s.cookies.set('sessionid', sessionid)
        url = SERVER + '/session/' + sessionid
        r = s.patch(url)
        r.raise_for_status()
        return s

    def create_session(s):
        url = SERVER + '/session'
        import getpass
        # username = input("Username:")
        # password = getpass.getpass("Password for {:}:".format(username))
        username, password = USER, PASSWD
        r = s.post(url, auth=requests.auth.HTTPBasicAuth(username, password))
        r.raise_for_status()
        resp = r.json()
        sessionid = resp['id']
        s.cookies.set('sessionid', sessionid)
        #-- write to file
        with open(FNAME, 'w') as f:
            f.write(sessionid)
        return s

    s = requests.Session()
    #-- restore session
    try:
        return restore_session(s)
    except: pass
    #-- create new session if restore failed
    return create_session(s)

def fetch_timeseries(s, timebracket, sites=[], fields=[]):
    '''Fetch metadata timeseries data from server'''
    url = SERVER + '/data/history'

    tail = ['observatory=' + s for s in sites]
    tail += ['field=' + f for f in fields]
    tail += ['startTime=%d' % timebracket[0], 'endTime=%d' % timebracket[1]]
    if len(tail) > 0:
        url += '?' + '&'.join(tail)

    r = s.get(url)
    r.raise_for_status()
    return r.json()

def make_groupTimelines(states, ks, xs, ix_dirty):
    if len(ix_dirty) > 0: ix_dirty_ = ix_dirty + [len(xs)-1]
    index = {}
    indexc = {}
    groupRecorder = {}
    for ir in range(1, 5):
        for ig in 'abcd':
            k = 'recorder_{:}_group{:}ModuleIDs'.format(ir, ig)
            try:
                index[k] = ks.index(k)
            except ValueError: continue
            groupRecorder[k] = ir
            #-- if Chainlabel doesn't exist, we also drop ModuleIDs
            kc = 'recorder_{:}_group{:}Chainlabel'.format(ir, ig)
            try:
                indexc[k] = ks.index(kc)
            except ValueError:
                indexc[k] = None

    groupTracks = {}
    for k, i in index.items():
        prev = None
        for iix, ix in enumerate(ix_dirty):
            modIDs = states[ix][i]
            if modIDs == None: continue

            try:
                chainlabel = states[ix][indexc[k]]
            except TypeError: chainlabel = 'undefined'
            if chainlabel == '': chainlabel = 'undefined'

            #-- continue previous track if no changes
            if modIDs == prev  and  groupTracks[modIDs][-1]['chainlabel'] == chainlabel:
                lastTrack = groupTracks[modIDs][-1]
                lastTrack['time'][1] = xs[ix_dirty_[iix+1]]
                continue
            prev = modIDs

            if not modIDs in groupTracks: groupTracks[modIDs] = []

            nextTrack = {
                'recorder': groupRecorder[k],
                'chainlabel': chainlabel,
                'time': [xs[ix], xs[ix_dirty_[iix+1]]],
                }
            groupTracks[modIDs].append(nextTrack)

    return groupTracks


def make_modules_timeline(states, ks):
    '''Create timeline of module state changes'''
    index = {}
    #-- loop recorders
    for ir in range(1, 5):
        #-- loop groups
        for ig in 'abcd':
            k = 'recorder_{:}_group{:}Chainlabel'.format(ir, ig)
            try:
                index[k] = ks.index(k)
            except ValueError: continue
    for ir in range(1, 5):
        for ig in 'abcd':
            k = 'recorder_{:}_group{:}ModuleIDs'.format(ir, ig)
            try:
                index[k] = ks.index(k)
            except ValueError: continue

    #-- find x coordinates where state changes
    state = len(index) * [None]
    ix_dirty = []
    for ix, st in enumerate(states):
        dirty = False
        for j, (k, i) in enumerate(index.items()):
            if state[j] == st[i]: continue
            #print(k, i, j, state[j], st[i])
            state[j] = st[i]
            dirty = True
        if dirty: ix_dirty.append(ix)

    return ix_dirty


def make_scans_timeline(states, ks):
    '''Create timeline of module state changes'''
    index = {}
    #-- loop recorders
    for ir in range(1, 5):
        #-- loop groups
        for ig in 'abcd':
            k = 'recorder_{:}_group{:}Chainlabel'.format(ir, ig)
            try:
                index[k] = ks.index(k)
            except ValueError: pass
            k = 'recorder_{:}_group{:}Spooling'.format(ir, ig)
            try:
                index[k] = ks.index(k)
            except ValueError: pass
    for ir in range(1, 5):
        for ig in 'abcd':
            k = 'recorder_{:}_group{:}ModuleIDs'.format(ir, ig)
            try:
                index[k] = ks.index(k)
            except ValueError: pass

    #-- find x coordinates where state changes
    state = len(index) * [None]
    ix_dirty = []
    for ix, st in enumerate(states):
        dirty = False
        for j, (k, i) in enumerate(index.items()):
            if state[j] == st[i]: continue
            #print(k, i, j, state[j], st[i])
            state[j] = st[i]
            dirty = True
        if dirty: ix_dirty.append(ix)

    return ix_dirty


def extend_with_groupModuleIDs(states_in, ks_in):
    '''Print table for one site'''
    index = {}
    #-- loop recorders
    for ir in range(1, 5):
        #-- loop groups
        for ig in 'abcd':
            k = 'recorder_{:}_group{:}Modules'.format(ir, ig)
            try:
                index[k] = ks_in.index(k)
            except ValueError: pass
        for im in range(1, 5):
            k = 'recorder_{:}_module{:}ID'.format(ir, im)
            try:
                index[k] = ks_in.index(k)
            except ValueError: pass

    ks = list(ks_in)
    for ir in range(1, 5):
        for ig in 'abcd':
            #k = 'recorder_{:}_group{:}Modules'.format(ir, ig)
            #if not k in index: continue
            k = 'recorder_{:}_group{:}ModuleIDs'.format(ir, ig)
            ks.append(k)

    states = []
    for st in states_in:
        state = list(st)
        #-- loop recorders
        for ir in range(1, 5):
            #-- loop groups
            for ig in 'abcd':
                k = 'recorder_{:}_group{:}Modules'.format(ir, ig)
                try:
                    i = index[k]
                except KeyError:
                    state.append(None)
                    continue
                grpMods = st[i]

                if grpMods == '' or grpMods == None:
                    state.append(None)
                    continue

                groupModuleIDs = []
                for m in grpMods.split(','):
                    try:
                        k = 'recorder_{:}_module{:}ID'.format(ir, m)
                        modID = st[index[k]]
                    except KeyError: 
                        modID = 'undefined'  #-- actually better 'incorrect'
                    if modID is None: modID = 'undefined'
                    groupModuleIDs.append(modID)
                state.append(','.join(groupModuleIDs))
        states.append(state)
    return states, ks




#-- turn parallel timeseries into sequence of states
def make_state_series(d):
    ks = list(d.keys())

    xs = []
    for k in ks:
        for v in d[k]: xs.append(v[0])
    #-- uniq sort
    xs = list(set(xs))
    xs.sort()

    state = len(ks) * [None]
    states = []
    for x in xs:
        #n = 0
        for i, k in enumerate(ks):
            if len(d[k]) == 0: continue
            if d[k][0][0] < x:
                #print(k, d[k][0], x)
                #print('WARNING: duplicate time stamps in data: dropping later points')
                continue
            if d[k][0][0] > x: continue
            #-- this point updates the state now
            v = d[k].pop(0)
            state[i] = v[1]
            #n += 1
        states.append(list(state))
        ##-- all drawn down
        #if n == 0: break

    return states, ks, xs


def list_modules(session, timebracket, sites):

    fields = []
    for ir in range(1, 5):
        modID = ['recorder_{:}_status'.format(ir)]
        #-- loop modules
        for im in [1, 2, 3, 4]:
            modID = ['recorder_{:}_module{:}ID'.format(ir, im)]
            fields += modID
    
        #-- loop groups
        for ig in 'abcd':
            fields += ['recorder_{:}_group{:}Modules'.format(ir, ig)]
            fields += ['recorder_{:}_group{:}Chainlabel'.format(ir, ig)]
            fields += ['recorder_{:}_group{:}Spooling'.format(ir, ig)]

    print(fields)

    ss = fetch_timeseries(session, timebracket, sites, fields)

    #-- create time series
    tss = {}
    for sitename, val in ss.items():
        states, ks, xs = make_state_series(val)
        states, ks = extend_with_groupModuleIDs(states, ks)
        ix_dirty = make_modules_timeline(states, ks)
        groupTracks = make_groupTimelines(states, ks, xs, ix_dirty)
        print()
        print('------------')
        print(sitename, '(%d)'%len(groupTracks))
        print('------------')
        for k, v in groupTracks.items():
            print(k)
            for o in v:
                td = [datetime.datetime.utcfromtimestamp(t).isoformat() for t in o['time']]
                print('\t', '%-11s' % o['chainlabel'], ' [ {:} -- {:} ] '.format(*td), 'recorder%d'%o['recorder'])


def list_clocks(session, timebracket, sites):

    fields = ['maser_driftRate', 'r2dbe_1_ppsOffset', 'r2dbe_2_ppsOffset', 'r2dbe_3_ppsOffset', 'r2dbe_4_ppsOffset']
    ss = session.fetch_timeseries(timebracket, sites, fields)

    # rate: beta = sum(x*y) / sum(x^2)

    for sitename, val in ss.items():
       states, keyname, uxtime = make_state_series(val)
       print (sitename, uxtime)
       xysum = [0.0 for v in val]
       xxsum = 0.0
       tstart = -1
       for (t,offsets) in zip(uxtime,states):
           if tstart < 0:
              tstart = t-1  # not =t to avoid divide by zero in xy/t^2
           offsets = [0.0 if offset==None else float(offset)/256e6 for offset in offsets]

           xysum = [xysum[i] + offsets[i]*(t-tstart) for i in range(len(val))]
           xxsum = xxsum + (t-tstart)*(t-tstart)
           # TODO: better use Kahan or Shewchuck summation, e.g., https://pypi.org/project/accupy/,
           # or get rid of loop and use math.fsum() which is base on Shewchuck

           rate = sum([xy/xxsum for xy in xysum]) / len(xysum)
           tpretty = datetime.datetime.utcfromtimestamp(int(t))
           print(tpretty,offsets,'usec; rate est. ',rate*1e-6,'sec/sec')

def main():

    dbsession = dbSession()

    # 2018:
    # 20-21 April (110-111) c21
    # 21-22 April (111-112) e22
    # 24 April (114) a24
    # 24-25 April (114-115) c25
    # 26-27 April (116-117) g27
    # 27-28 April (117-118) d28

    t0 = datetime.datetime(2021, 4, 20)
    t1 = datetime.datetime(2021, 4, 24)
    timebracket = [calendar.timegm(t0.timetuple()), calendar.timegm(t1.timetuple())]

    #sites = ['PICO', 'JCMT', 'KP', 'NOEMA', 'SMTO', 'SMA', 'SPT', 'GLT', 'APEX']
    #sites = ['PICO', 'JCMT', 'KP', 'NOEMA', 'SMTO', 'SMA', 'GLT', 'APEX']
    #sites = ['SMTO']
    sites = ['SMTO']

    # list_modules(dbsession, timebracket, sites)
    list_clocks(dbsession, timebracket, sites)

if __name__ == '__main__':
    main()

# vim: foldmethod=indent
