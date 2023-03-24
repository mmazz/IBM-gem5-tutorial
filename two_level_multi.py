import m5
# import all of the SimObjects
from m5.objects import *
from gem5.runtime import get_runtime_isa
# Add the common scripts to our path
m5.util.addToPath("../../")
# import the caches which we made
from caches import *
# import the SimpleOpts module
from common import SimpleOpts
# Default to running 'hello', use the compiled ISA to find the binary
# grab the specific path to the binary
thispath = os.path.dirname(os.path.realpath(__file__))
default_binary = os.path.join(
    thispath,
    "../../../",
    "tests/test-progs/hello/bin/x86/linux/hello",
    #"tests/test-progs/hello/hello",
)
# Binary to execute
SimpleOpts.add_option("binary", nargs="?", default=default_binary)


# Finalize the arguments and grab the args so we can pass it on to our objects
args = SimpleOpts.parse_args()

num_cpus = 2

# create the system we are going to simulate
system = System()
# Set the clock frequency of the system (and all of its children)
system.clk_domain = SrcClockDomain()
system.clk_domain.clock = "1GHz"
system.clk_domain.voltage_domain = VoltageDomain()
# Set up the system
system.mem_mode = "timing"  # Use timing accesses
system.mem_ranges = [AddrRange("512MB")]  # Create an address range
# Create a simple CPU
cpus = []
for i in range(num_cpus):
    cpu = X86TimingSimpleCPU(cpu_id=i, clk_domain=system.clk_domain)
    cpus.append(cpu)

system.membus = CoherentXBar(frontend_latency=10)
system.l2bus = L2XBar()
system.l2cache = L2Cache(args)
system.l2cache.connectCPUSideBus(system.l2bus)
system.l2cache.connectMemSideBus(system.membus)

# Connect the system up to the membus
system.system_port = system.membus.cpu_side_ports
system.mem_ctrl = MemCtrl()
system.mem_ctrl.dram = DDR3_1600_8x8()
system.mem_ctrl.dram.range = system.mem_ranges[0]
system.mem_ctrl.port = system.membus.mem_side_ports
system.workload = SEWorkload.init_compatible(args.binary)


process = Process(cmd=args.binary)

for cpu in cpus:
#    process = Process(pid=cpu.cpu_id)
#    process.cmd = [args.binary]
    cpu.icache = L1ICache(args)
    cpu.dcache = L1DCache(args)
    cpu.icache.connectCPU(cpu)
    cpu.dcache.connectCPU(cpu)
    cpu.icache.connectBus(system.l2bus)
    cpu.dcache.connectBus(system.l2bus)
    cpu.createInterruptController()
    cpu.interrupts[0].pio = system.membus.mem_side_ports
    cpu.interrupts[0].int_requestor = system.membus.cpu_side_ports
    cpu.interrupts[0].int_responder = system.membus.mem_side_ports
    cpu.createThreads()
    cpu.workload = process
system.cpu = cpus
# set up the root SimObject and start the simulation
root = Root(full_system=False, system=system)
# instantiate all of the objects we've created above
m5.instantiate()
print("Beginning simulation!")
exit_event = m5.simulate()
print("Exiting @ tick %i because %s" % (m5.curTick(), exit_event.getCause()))


