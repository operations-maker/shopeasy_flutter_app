import React, { useState } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { 
  Play, 
  Pause, 
  AlertOctagon, 
  Clock, 
  Gauge, 
  Flame, 
  TrendingUp, 
  UserCheck, 
  Layers, 
  CheckCircle
} from 'lucide-react';

interface MachineData {
  id: string;
  name: string;
  code: string;
  status: 'Running' | 'Idle' | 'Downtime' | 'Maintenance';
  operator: string;
  oee: number;
  temperature: number;
  vibration: number;
  targetCount: number;
  completedCount: number;
}

export const ShopFloor: React.FC = () => {
  const [machines, setMachines] = useState<MachineData[]>([
    { id: '1', name: 'CNC Milling Machine 5-Axis', code: 'MC-CNC-01', status: 'Running', operator: 'Rajesh Kumar', oee: 89.4, temperature: 68.5, vibration: 0.04, targetCount: 200, completedCount: 165 },
    { id: '2', name: 'Robotic Assembly Arm Alpha', code: 'MC-ASM-02', status: 'Idle', operator: 'Amit Sharma', oee: 78.1, temperature: 42.0, vibration: 0.01, targetCount: 150, completedCount: 110 },
    { id: '3', name: 'High-Precision Laser Cutter', code: 'MC-LSR-03', status: 'Downtime', operator: 'Vikram Singh', oee: 54.2, temperature: 95.1, vibration: 0.18, targetCount: 120, completedCount: 65 },
    { id: '4', name: 'Plastics Injection Molder B', code: 'MC-MOLD-04', status: 'Running', operator: 'Pooja Patel', oee: 92.6, temperature: 180.4, vibration: 0.06, targetCount: 500, completedCount: 485 },
  ]);

  const [selectedMachine, setSelectedMachine] = useState<MachineData | null>(null);
  const [downtimeReason, setDowntimeReason] = useState<string>('');
  const [isDowntimeModalOpen, setIsDowntimeModalOpen] = useState(false);

  const handleStatusChange = (id: string, newStatus: 'Running' | 'Idle' | 'Downtime' | 'Maintenance') => {
    setMachines(prev => prev.map(m => {
      if (m.id === id) {
        return {
          ...m,
          status: newStatus,
          // simulated vibration and temperature changes
          vibration: newStatus === 'Running' ? 0.05 : newStatus === 'Downtime' ? 0.12 : 0.01,
          temperature: newStatus === 'Running' ? 70 : newStatus === 'Downtime' ? 90 : 35
        };
      }
      return m;
    }));
  };

  const submitDowntime = () => {
    if (!selectedMachine) return;
    handleStatusChange(selectedMachine.id, 'Downtime');
    setIsDowntimeModalOpen(false);
    setDowntimeReason('');
  };

  return (
    <div className="space-y-8">
      {/* Page Header */}
      <div className="flex justify-between items-center">
        <div>
          <h2 className="text-3xl font-extrabold text-slate-800 dark:text-white tracking-tight">Shop Floor Console</h2>
          <p className="text-slate-500 dark:text-slate-400 mt-1">Live operator workcell monitoring, machine control, and shift telemetry.</p>
        </div>
        
        {/* Shift Summary Card */}
        <div className="flex gap-4">
          <div className="glass px-4 py-2.5 rounded-xl border border-slate-200 dark:border-slate-800 flex items-center gap-3">
            <UserCheck className="w-5 h-5 text-blue-600" />
            <div className="text-xs">
              <p className="font-bold text-slate-700 dark:text-slate-300">Shift A (Morning)</p>
              <p className="text-[10px] text-slate-500 font-semibold uppercase tracking-wider">06:00 - 14:00</p>
            </div>
          </div>
          <div className="glass px-4 py-2.5 rounded-xl border border-slate-200 dark:border-slate-800 flex items-center gap-3">
            <Layers className="w-5 h-5 text-emerald-600" />
            <div className="text-xs">
              <p className="font-bold text-slate-700 dark:text-slate-300">Target Progress</p>
              <p className="text-[10px] text-emerald-600 font-bold uppercase tracking-wider">825 / 970 Units (85%)</p>
            </div>
          </div>
        </div>
      </div>

      {/* Grid of Workcell Cards */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        {machines.map((machine) => {
          const statusColors = {
            Running: 'bg-emerald-500 text-white shadow-emerald-500/20',
            Idle: 'bg-amber-500 text-white shadow-amber-500/20',
            Downtime: 'bg-rose-500 text-white shadow-rose-500/20',
            Maintenance: 'bg-indigo-500 text-white shadow-indigo-500/20',
          };

          const progressPercent = Math.min(Math.round((machine.completedCount / machine.targetCount) * 100), 100);

          return (
            <motion.div
              layout
              key={machine.id}
              className="bg-white dark:bg-slate-900 rounded-2xl border border-slate-200/60 dark:border-slate-800/60 card-shadow overflow-hidden flex flex-col justify-between"
            >
              {/* Card Top */}
              <div className="p-6 space-y-4">
                <div className="flex justify-between items-start">
                  <div>
                    <span className="text-[10px] font-extrabold text-slate-400 font-mono tracking-widest uppercase">{machine.code}</span>
                    <h3 className="text-lg font-bold text-slate-800 dark:text-white mt-0.5">{machine.name}</h3>
                  </div>
                  <div className={`px-3 py-1 rounded-full text-xs font-bold shadow-md ${statusColors[machine.status]}`}>
                    {machine.status}
                  </div>
                </div>

                {/* Telemetry Dials */}
                <div className="grid grid-cols-3 gap-4 pt-2">
                  <div className="bg-slate-50 dark:bg-slate-800/40 p-3.5 rounded-xl border border-slate-100 dark:border-slate-800/60 flex flex-col gap-1.5">
                    <div className="flex items-center gap-1.5 text-slate-400">
                      <Gauge className="w-3.5 h-3.5" />
                      <span className="text-[10px] font-bold uppercase tracking-wider">OEE Score</span>
                    </div>
                    <span className="text-lg font-extrabold text-slate-800 dark:text-white">{machine.oee}%</span>
                  </div>

                  <div className="bg-slate-50 dark:bg-slate-800/40 p-3.5 rounded-xl border border-slate-100 dark:border-slate-800/60 flex flex-col gap-1.5">
                    <div className="flex items-center gap-1.5 text-slate-400">
                      <Flame className="w-3.5 h-3.5" />
                      <span className="text-[10px] font-bold uppercase tracking-wider">Temp</span>
                    </div>
                    <span className={`text-lg font-extrabold ${machine.temperature > 85 ? 'text-rose-500' : 'text-slate-800 dark:text-white'}`}>
                      {machine.temperature}°C
                    </span>
                  </div>

                  <div className="bg-slate-50 dark:bg-slate-800/40 p-3.5 rounded-xl border border-slate-100 dark:border-slate-800/60 flex flex-col gap-1.5">
                    <div className="flex items-center gap-1.5 text-slate-400">
                      <TrendingUp className="w-3.5 h-3.5" />
                      <span className="text-[10px] font-bold uppercase tracking-wider">Vibration</span>
                    </div>
                    <span className={`text-lg font-extrabold ${machine.vibration > 0.1 ? 'text-rose-500' : 'text-slate-800 dark:text-white'}`}>
                      {machine.vibration} Gs
                    </span>
                  </div>
                </div>

                {/* Production Count Slider */}
                <div className="space-y-1.5 pt-2">
                  <div className="flex justify-between text-xs font-semibold">
                    <span className="text-slate-400">Output Progress</span>
                    <span className="text-slate-700 dark:text-slate-300">{machine.completedCount} / {machine.targetCount} units</span>
                  </div>
                  <div className="w-full h-2.5 bg-slate-100 dark:bg-slate-800 rounded-full overflow-hidden">
                    <div className="h-full bg-blue-600 rounded-full transition-all duration-300" style={{ width: `${progressPercent}%` }} />
                  </div>
                </div>
              </div>

              {/* Operator details & Control Actions */}
              <div className="bg-slate-50 dark:bg-slate-800/30 px-6 py-4 border-t border-slate-100 dark:border-slate-800 flex justify-between items-center gap-4">
                <div className="text-xs">
                  <p className="text-slate-400">Operator</p>
                  <p className="font-bold text-slate-800 dark:text-white mt-0.5">{machine.operator}</p>
                </div>

                {/* Control Action Buttons */}
                <div className="flex items-center gap-2">
                  {machine.status !== 'Running' ? (
                    <button 
                      onClick={() => handleStatusChange(machine.id, 'Running')}
                      className="p-2 rounded-lg bg-emerald-50 hover:bg-emerald-100 text-emerald-600 dark:bg-emerald-950/20 dark:hover:bg-emerald-950/40 transition-colors"
                      title="Start Operation"
                    >
                      <Play className="w-4 h-4 fill-emerald-600" />
                    </button>
                  ) : (
                    <button 
                      onClick={() => handleStatusChange(machine.id, 'Idle')}
                      className="p-2 rounded-lg bg-amber-50 hover:bg-amber-100 text-amber-600 dark:bg-amber-950/20 dark:hover:bg-amber-950/40 transition-colors"
                      title="Pause Operation (Idle)"
                    >
                      <Pause className="w-4 h-4 fill-amber-600" />
                    </button>
                  )}
                  
                  <button 
                    onClick={() => {
                      setSelectedMachine(machine);
                      setIsDowntimeModalOpen(true);
                    }}
                    className="p-2 rounded-lg bg-rose-50 hover:bg-rose-100 text-rose-600 dark:bg-rose-950/20 dark:hover:bg-rose-950/40 transition-colors"
                    title="Log Downtime Event"
                  >
                    <AlertOctagon className="w-4 h-4" />
                  </button>
                </div>
              </div>
            </motion.div>
          );
        })}
      </div>

      {/* Live Downtime Logs (Activity stream) */}
      <div className="bg-white dark:bg-slate-900 rounded-2xl border border-slate-200/60 dark:border-slate-800/60 card-shadow p-6 space-y-4">
        <div className="flex justify-between items-center">
          <h4 className="text-sm font-bold text-slate-800 dark:text-white">Active Shift Maintenance & Downtime Log</h4>
          <span className="text-xs bg-red-100 dark:bg-red-950/30 text-red-600 px-2 py-0.5 rounded font-bold uppercase">1 active issue</span>
        </div>

        <div className="divide-y divide-slate-100 dark:divide-slate-800">
          <div className="py-3 flex justify-between items-center text-xs">
            <div className="flex gap-3 items-center">
              <Clock className="w-4 h-4 text-rose-500" />
              <div>
                <p className="font-bold text-slate-700 dark:text-slate-300">MC-LSR-03 (High-Precision Laser Cutter)</p>
                <p className="text-slate-400">Triggered: 10:14 AM | Reason: Laser unit thermal trip</p>
              </div>
            </div>
            <span className="font-mono text-rose-500 font-bold bg-rose-50 dark:bg-rose-950/20 px-2 py-1 rounded">Downtime 48 min</span>
          </div>

          <div className="py-3 flex justify-between items-center text-xs">
            <div className="flex gap-3 items-center">
              <CheckCircle className="w-4 h-4 text-emerald-500" />
              <div>
                <p className="font-bold text-slate-700 dark:text-slate-300">MC-ASM-02 (Robotic Assembly Arm Alpha)</p>
                <p className="text-slate-400">Resolved: 09:22 AM | Duration: 12 min | Reason: Sensor calibration</p>
              </div>
            </div>
            <span className="font-mono text-slate-400 bg-slate-50 dark:bg-slate-800 px-2 py-1 rounded">Resolved</span>
          </div>
        </div>
      </div>

      {/* Downtime Reason Modal Dialog */}
      <AnimatePresence>
        {isDowntimeModalOpen && (
          <div className="fixed inset-0 bg-slate-950/50 backdrop-blur-sm z-50 flex items-center justify-center p-4">
            <motion.div
              initial={{ scale: 0.95, opacity: 0 }}
              animate={{ scale: 1, opacity: 1 }}
              exit={{ scale: 0.95, opacity: 0 }}
              className="bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-2xl max-w-md w-full p-6 space-y-4 shadow-xl"
            >
              <div className="flex items-center gap-3 text-rose-600">
                <AlertOctagon className="w-6 h-6" />
                <h3 className="text-lg font-bold">Report Operator Downtime</h3>
              </div>
              <p className="text-xs text-slate-400">
                Specify the cause of halt for machine <strong>{selectedMachine?.name} ({selectedMachine?.code})</strong>. This will log in EF Core and adjust OEE in real-time.
              </p>
              
              <div className="space-y-3">
                <label className="text-xs font-bold text-slate-500 uppercase tracking-wider block">Downtime Category</label>
                <select 
                  value={downtimeReason} 
                  onChange={(e) => setDowntimeReason(e.target.value)}
                  className="w-full bg-slate-100 dark:bg-slate-800 border-0 rounded-xl px-4 py-3 text-sm focus:ring-2 focus:ring-rose-500 focus:outline-none"
                >
                  <option value="">Select Reason...</option>
                  <option value="Mechanical Failure">Mechanical / Hydraulic Failure</option>
                  <option value="Tool / Blade Change">Tool / Cutter Wear Change</option>
                  <option value="Material Shortage">Raw Material Stock Out</option>
                  <option value="Operator Absent">No Operator Available</option>
                  <option value="Quality Halt">Quality Inspection Hold</option>
                </select>
              </div>

              <div className="flex justify-end gap-3 pt-2">
                <button 
                  onClick={() => setIsDowntimeModalOpen(false)}
                  className="px-4 py-2 text-xs font-bold text-slate-400 hover:text-slate-600 transition-colors"
                >
                  Cancel
                </button>
                <button 
                  onClick={submitDowntime}
                  disabled={!downtimeReason}
                  className="px-5 py-2.5 text-xs font-bold text-white bg-rose-600 hover:bg-rose-700 rounded-xl disabled:opacity-50 disabled:cursor-not-allowed shadow-md shadow-rose-500/20 transition-all"
                >
                  Report Halt
                </button>
              </div>
            </motion.div>
          </div>
        )}
      </AnimatePresence>
    </div>
  );
};
