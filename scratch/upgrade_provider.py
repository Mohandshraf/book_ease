import re

def upgrade_provider_screens():
    with open('app_design_preview.html', 'r', encoding='utf-8') as f:
        html = f.read()

    # 1. New Provider Services Screen (Screen 24)
    new_provider_services = """      // ==========================================
      // 24. PROVIDER SERVICES & PRICING MANAGEMENT (PRO HEALTHCARE SUITE)
      // ==========================================
      provider_services: {
        id: 'provider_services',
        num: '24',
        title: '24. Services & Pricing Management',
        category: 'provider',
        role: 'provider',
        hasNav: true,
        render: () => `
          <div class="phone-screen p-5 bg-[#F5F6F8] flex flex-col justify-between screen-fade">
            <div class="overflow-y-auto pr-0.5 pb-4">
              
              <!-- Top Header -->
              <div class="flex items-center justify-between mb-4 pt-1">
                <div>
                  <div class="flex items-center gap-1.5 mb-0.5">
                    <span class="w-2 h-2 rounded-full bg-emerald-500 animate-pulse"></span>
                    <span class="text-[10px] text-slate-500 font-semibold">Dr. Ali Khan • Cardiology Clinic</span>
                  </div>
                  <h3 class="text-base font-extrabold text-slate-900">Services & Pricing</h3>
                </div>
                <button class="px-3.5 py-1.5 rounded-full bg-[#7C3AED] hover:bg-[#6D28D9] text-white text-xs font-bold shadow-sm shadow-purple-500/25 flex items-center gap-1 cursor-pointer transition-all">
                  <i class="fa-solid fa-plus text-[10px]"></i> Add
                </button>
              </div>

              <!-- Quick Search & Category Filter Pills -->
              <div class="relative mb-3">
                <span class="absolute inset-y-0 left-0 pl-3.5 flex items-center text-slate-400 text-xs"><i class="fa-solid fa-magnifying-glass"></i></span>
                <input type="text" placeholder="Search service name, category, or code..." class="w-full pl-9 pr-4 py-2 bg-white border border-slate-200/80 rounded-2xl text-xs font-medium text-slate-900 placeholder:text-slate-400 focus:border-[#7C3AED] outline-none shadow-xs" />
              </div>

              <!-- Filter Pills -->
              <div class="flex gap-1.5 overflow-x-auto pb-2 mb-3.5 scrollbar-none">
                <button class="px-3 py-1.5 rounded-xl bg-[#7C3AED] text-white text-[11px] font-bold shadow-xs shadow-purple-500/20 whitespace-nowrap">All (8)</button>
                <button class="px-3 py-1.5 rounded-xl bg-white border border-slate-200 text-slate-600 text-[11px] font-semibold hover:border-purple-400 whitespace-nowrap">🩺 Consultations (3)</button>
                <button class="px-3 py-1.5 rounded-xl bg-white border border-slate-200 text-slate-600 text-[11px] font-semibold hover:border-purple-400 whitespace-nowrap">🩻 Diagnostics (3)</button>
                <button class="px-3 py-1.5 rounded-xl bg-white border border-slate-200 text-slate-600 text-[11px] font-semibold hover:border-purple-400 whitespace-nowrap">💻 Telehealth (2)</button>
              </div>

              <!-- Services Performance Banner -->
              <div class="bg-gradient-to-r from-[#7C3AED] via-[#8B5CF6] to-[#6D28D9] rounded-3xl p-4 text-white shadow-lg shadow-purple-500/20 mb-4">
                <div class="flex items-center justify-between mb-2">
                  <span class="text-xs font-bold text-purple-100 flex items-center gap-1.5"><i class="fa-solid fa-chart-line"></i> Service Catalog Health</span>
                  <span class="bg-white/20 text-[10px] font-bold px-2 py-0.5 rounded-full">8 Active Offerings</span>
                </div>
                <div class="grid grid-cols-3 gap-2 text-center pt-2 border-t border-white/10">
                  <div>
                    <span class="text-base font-extrabold block">$145</span>
                    <span class="text-[9px] text-purple-200 font-medium">Avg. Fee</span>
                  </div>
                  <div>
                    <span class="text-base font-extrabold text-emerald-300 block">94%</span>
                    <span class="text-[9px] text-purple-200 font-medium">Fill Rate</span>
                  </div>
                  <div>
                    <span class="text-base font-extrabold text-amber-300 block">Echo Scan</span>
                    <span class="text-[9px] text-purple-200 font-medium">Top Service</span>
                  </div>
                </div>
              </div>

              <!-- Service List Cards -->
              <div class="space-y-3 mb-2">
                
                <!-- Service 1: Initial Consultation -->
                <div class="bg-white rounded-3xl p-4 border border-slate-100 shadow-sm">
                  <div class="flex items-start justify-between mb-2.5">
                    <div class="flex items-center gap-3">
                      <div class="w-10 h-10 rounded-2xl bg-purple-50 text-[#7C3AED] flex items-center justify-center text-sm font-bold shrink-0">
                        <i class="fa-solid fa-user-doctor"></i>
                      </div>
                      <div>
                        <div class="flex items-center gap-2 mb-0.5">
                          <h4 class="text-xs font-extrabold text-slate-900">Initial Cardiology Consultation</h4>
                          <span class="bg-emerald-50 text-emerald-600 border border-emerald-100 text-[9px] font-bold px-2 py-0.2 rounded-full">Active</span>
                        </div>
                        <p class="text-[10px] text-slate-400 font-medium">30 Mins • In-Clinic & Video Consultation</p>
                      </div>
                    </div>
                    <span class="text-sm font-black text-[#7C3AED]">$120</span>
                  </div>

                  <!-- Service Settings Badges -->
                  <div class="flex flex-wrap gap-1.5 my-2 pt-2 border-t border-slate-50 text-[9px]">
                    <span class="bg-slate-100 text-slate-600 px-2 py-0.5 rounded-md font-medium"><i class="fa-solid fa-clock-rotate-left text-slate-400"></i> +10m Buffer</span>
                    <span class="bg-purple-50 text-[#7C3AED] px-2 py-0.5 rounded-md font-semibold"><i class="fa-solid fa-bolt"></i> Auto-Confirm: ON</span>
                    <span class="bg-slate-100 text-slate-600 px-2 py-0.5 rounded-md font-medium">2h Min. Notice</span>
                  </div>

                  <div class="flex items-center justify-between pt-2 border-t border-slate-100 text-[10px]">
                    <span class="text-slate-400"><i class="fa-regular fa-calendar-check"></i> 14 booked this week</span>
                    <div class="flex gap-1.5">
                      <button class="px-2.5 py-1 rounded-xl bg-slate-100 hover:bg-slate-200 text-slate-700 font-bold">Edit</button>
                      <button class="px-2.5 py-1 rounded-xl bg-purple-50 hover:bg-purple-100 text-[#7C3AED] font-bold">Rules</button>
                    </div>
                  </div>
                </div>

                <!-- Service 2: Heart Echo Scan -->
                <div class="bg-white rounded-3xl p-4 border border-slate-100 shadow-sm">
                  <div class="flex items-start justify-between mb-2.5">
                    <div class="flex items-center gap-3">
                      <div class="w-10 h-10 rounded-2xl bg-blue-50 text-blue-600 flex items-center justify-center text-sm font-bold shrink-0">
                        <i class="fa-solid fa-heart-pulse"></i>
                      </div>
                      <div>
                        <div class="flex items-center gap-2 mb-0.5">
                          <h4 class="text-xs font-extrabold text-slate-900">Color Doppler Echocardiogram</h4>
                          <span class="bg-emerald-50 text-emerald-600 border border-emerald-100 text-[9px] font-bold px-2 py-0.2 rounded-full">Active</span>
                        </div>
                        <p class="text-[10px] text-slate-400 font-medium">45 Mins • In-Clinic Ultrasound Suite 1</p>
                      </div>
                    </div>
                    <span class="text-sm font-black text-[#7C3AED]">$250</span>
                  </div>

                  <!-- Service Settings Badges -->
                  <div class="flex flex-wrap gap-1.5 my-2 pt-2 border-t border-slate-50 text-[9px]">
                    <span class="bg-slate-100 text-slate-600 px-2 py-0.5 rounded-md font-medium"><i class="fa-solid fa-clock-rotate-left text-slate-400"></i> +15m Buffer</span>
                    <span class="bg-amber-50 text-amber-700 px-2 py-0.5 rounded-md font-semibold"><i class="fa-solid fa-shield-halved"></i> 50% Deposit Required</span>
                    <span class="bg-slate-100 text-slate-600 px-2 py-0.5 rounded-md font-medium">Includes PDF Report</span>
                  </div>

                  <div class="flex items-center justify-between pt-2 border-t border-slate-100 text-[10px]">
                    <span class="text-slate-400"><i class="fa-regular fa-calendar-check"></i> 9 booked this week</span>
                    <div class="flex gap-1.5">
                      <button class="px-2.5 py-1 rounded-xl bg-slate-100 hover:bg-slate-200 text-slate-700 font-bold">Edit</button>
                      <button class="px-2.5 py-1 rounded-xl bg-purple-50 hover:bg-purple-100 text-[#7C3AED] font-bold">Rules</button>
                    </div>
                  </div>
                </div>

                <!-- Service 3: Telehealth Follow-Up -->
                <div class="bg-white rounded-3xl p-4 border border-slate-100 shadow-sm">
                  <div class="flex items-start justify-between mb-2.5">
                    <div class="flex items-center gap-3">
                      <div class="w-10 h-10 rounded-2xl bg-emerald-50 text-emerald-600 flex items-center justify-center text-sm font-bold shrink-0">
                        <i class="fa-solid fa-video"></i>
                      </div>
                      <div>
                        <div class="flex items-center gap-2 mb-0.5">
                          <h4 class="text-xs font-extrabold text-slate-900">Virtual Follow-up Consultation</h4>
                          <span class="bg-emerald-50 text-emerald-600 border border-emerald-100 text-[9px] font-bold px-2 py-0.2 rounded-full">Active</span>
                        </div>
                        <p class="text-[10px] text-slate-400 font-medium">15 Mins • 100% Online Video Call</p>
                      </div>
                    </div>
                    <span class="text-sm font-black text-[#7C3AED]">$60</span>
                  </div>

                  <!-- Service Settings Badges -->
                  <div class="flex flex-wrap gap-1.5 my-2 pt-2 border-t border-slate-50 text-[9px]">
                    <span class="bg-emerald-50 text-emerald-700 px-2 py-0.5 rounded-md font-semibold"><i class="fa-solid fa-link"></i> Auto Video Room</span>
                    <span class="bg-slate-100 text-slate-600 px-2 py-0.5 rounded-md font-medium"><i class="fa-solid fa-pills"></i> e-Prescription Sync</span>
                  </div>

                  <div class="flex items-center justify-between pt-2 border-t border-slate-100 text-[10px]">
                    <span class="text-slate-400"><i class="fa-regular fa-calendar-check"></i> 18 booked this week</span>
                    <div class="flex gap-1.5">
                      <button class="px-2.5 py-1 rounded-xl bg-slate-100 hover:bg-slate-200 text-slate-700 font-bold">Edit</button>
                      <button class="px-2.5 py-1 rounded-xl bg-purple-50 hover:bg-purple-100 text-[#7C3AED] font-bold">Rules</button>
                    </div>
                  </div>
                </div>

                <!-- Service 4: Holter Monitoring -->
                <div class="bg-white rounded-3xl p-4 border border-slate-100 shadow-sm">
                  <div class="flex items-start justify-between mb-2.5">
                    <div class="flex items-center gap-3">
                      <div class="w-10 h-10 rounded-2xl bg-amber-50 text-amber-600 flex items-center justify-center text-sm font-bold shrink-0">
                        <i class="fa-solid fa-wave-square"></i>
                      </div>
                      <div>
                        <div class="flex items-center gap-2 mb-0.5">
                          <h4 class="text-xs font-extrabold text-slate-900">24-Hour Holter ECG Monitoring</h4>
                          <span class="bg-amber-50 text-amber-700 border border-amber-100 text-[9px] font-bold px-2 py-0.2 rounded-full">Limited Slots</span>
                        </div>
                        <p class="text-[10px] text-slate-400 font-medium">60 Mins Setup + 24h Analysis</p>
                      </div>
                    </div>
                    <span class="text-sm font-black text-[#7C3AED]">$190</span>
                  </div>

                  <div class="flex items-center justify-between pt-2 border-t border-slate-100 text-[10px]">
                    <span class="text-slate-400"><i class="fa-solid fa-microchip"></i> 4 Devices available</span>
                    <div class="flex gap-1.5">
                      <button class="px-2.5 py-1 rounded-xl bg-slate-100 hover:bg-slate-200 text-slate-700 font-bold">Edit</button>
                      <button class="px-2.5 py-1 rounded-xl bg-purple-50 hover:bg-purple-100 text-[#7C3AED] font-bold">Rules</button>
                    </div>
                  </div>
                </div>

              </div>

            </div>

            <!-- Sticky Add Service Button -->
            <div class="pt-3 bg-[#F5F6F8] border-t border-slate-200/60 sticky bottom-0">
              <button class="w-full py-3.5 rounded-2xl bg-[#7C3AED] hover:bg-[#6D28D9] text-white font-bold text-xs shadow-lg shadow-purple-500/30 flex items-center justify-center gap-2 transition-all cursor-pointer">
                <i class="fa-solid fa-plus text-xs"></i>
                <span>Create New Service Offering</span>
              </button>
            </div>

          </div>
        `
      },"""

    # 2. New Provider Availability & Clinic Settings Screen (Screen 25)
    new_provider_avail = """      // ==========================================
      // 25. PROVIDER AVAILABILITY & CLINIC SETTINGS (PRO HEALTHCARE SUITE)
      // ==========================================
      provider_avail: {
        id: 'provider_avail',
        num: '25',
        title: '25. Working Hours & Clinic Settings',
        category: 'provider',
        role: 'provider',
        hasNav: true,
        render: () => `
          <div class="phone-screen p-5 bg-[#F5F6F8] flex flex-col justify-between screen-fade">
            <div class="overflow-y-auto pr-0.5 pb-4">
              
              <!-- Top Navigation & Status -->
              <div class="flex items-center justify-between mb-4 pt-1">
                <div>
                  <div class="flex items-center gap-1.5 mb-0.5">
                    <span class="w-2 h-2 rounded-full bg-emerald-500 animate-pulse"></span>
                    <span class="text-[10px] text-emerald-600 font-bold">Auto-Syncing Google Calendar</span>
                  </div>
                  <h3 class="text-base font-extrabold text-slate-900">Availability & Rules</h3>
                </div>
                <span class="px-2.5 py-1 rounded-full bg-purple-50 text-[#7C3AED] text-[10px] font-bold">v2.4 Rules</span>
              </div>

              <!-- CARD 1: CLINIC APPOINTMENT RULES & BUFFER SETTINGS -->
              <div class="bg-white rounded-3xl p-4 border border-slate-100 shadow-sm mb-4">
                <div class="flex items-center justify-between mb-3 border-b border-slate-100 pb-2.5">
                  <h4 class="text-xs font-extrabold text-slate-900 uppercase tracking-wider flex items-center gap-1.5">
                    <i class="fa-solid fa-sliders text-[#7C3AED]"></i> Slot Duration & Buffers
                  </h4>
                  <span class="text-[10px] text-[#7C3AED] font-bold">Default Settings</span>
                </div>

                <!-- Slot Duration Options -->
                <div class="mb-3.5">
                  <label class="block text-[11px] font-bold text-slate-700 mb-1.5">Default Slot Interval</label>
                  <div class="grid grid-cols-4 gap-1.5 text-center">
                    <button class="py-2 rounded-xl bg-slate-100 text-slate-600 text-[11px] font-semibold hover:bg-slate-200">15 min</button>
                    <button class="py-2 rounded-xl bg-[#7C3AED] text-white text-[11px] font-bold shadow-xs shadow-purple-500/25">30 min</button>
                    <button class="py-2 rounded-xl bg-slate-100 text-slate-600 text-[11px] font-semibold hover:bg-slate-200">45 min</button>
                    <button class="py-2 rounded-xl bg-slate-100 text-slate-600 text-[11px] font-semibold hover:bg-slate-200">60 min</button>
                  </div>
                </div>

                <!-- Buffer Time Between Appointments -->
                <div class="mb-3.5">
                  <label class="block text-[11px] font-bold text-slate-700 mb-1.5">Buffer Time Between Patients</label>
                  <div class="grid grid-cols-4 gap-1.5 text-center">
                    <button class="py-2 rounded-xl bg-slate-100 text-slate-600 text-[11px] font-semibold hover:bg-slate-200">None</button>
                    <button class="py-2 rounded-xl bg-slate-100 text-slate-600 text-[11px] font-semibold hover:bg-slate-200">5 min</button>
                    <button class="py-2 rounded-xl bg-[#7C3AED] text-white text-[11px] font-bold shadow-xs shadow-purple-500/25">10 min</button>
                    <button class="py-2 rounded-xl bg-slate-100 text-slate-600 text-[11px] font-semibold hover:bg-slate-200">15 min</button>
                  </div>
                </div>

                <!-- Fast Automation Toggles -->
                <div class="space-y-2.5 pt-2 border-t border-slate-100">
                  <div class="flex items-center justify-between">
                    <div>
                      <span class="text-xs font-bold text-slate-900 block">Instant Auto-Confirmation</span>
                      <span class="text-[10px] text-slate-400 font-medium">Book appointments immediately without manual review</span>
                    </div>
                    <label class="relative inline-flex items-center cursor-pointer">
                      <input type="checkbox" checked class="sr-only peer" />
                      <div class="w-9 h-5 bg-slate-200 peer-focus:outline-none rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-slate-300 after:border after:rounded-full after:h-4 after:w-4 after:transition-all peer-checked:bg-[#7C3AED]"></div>
                    </label>
                  </div>

                  <div class="flex items-center justify-between">
                    <div>
                      <span class="text-xs font-bold text-slate-900 block">Telehealth Video Enabled</span>
                      <span class="text-[10px] text-slate-400 font-medium">Allow remote patient consultations via BookEase Room</span>
                    </div>
                    <label class="relative inline-flex items-center cursor-pointer">
                      <input type="checkbox" checked class="sr-only peer" />
                      <div class="w-9 h-5 bg-slate-200 peer-focus:outline-none rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-slate-300 after:border after:rounded-full after:h-4 after:w-4 after:transition-all peer-checked:bg-[#7C3AED]"></div>
                    </label>
                  </div>
                </div>

              </div>

              <!-- CARD 2: WEEKLY WORKING SHIFTS SCHEDULE -->
              <div class="bg-white rounded-3xl p-4 border border-slate-100 shadow-sm mb-4">
                <div class="flex items-center justify-between mb-3 border-b border-slate-100 pb-2.5">
                  <h4 class="text-xs font-extrabold text-slate-900 uppercase tracking-wider flex items-center gap-1.5">
                    <i class="fa-regular fa-calendar-days text-[#7C3AED]"></i> Weekly Shifts Schedule
                  </h4>
                  <span class="text-[10px] text-emerald-600 font-bold bg-emerald-50 px-2 py-0.5 rounded-full">34h Weekly</span>
                </div>

                <!-- Shift Item: Mon - Fri -->
                <div class="p-3 bg-slate-50 rounded-2xl border border-slate-200/80 mb-2.5">
                  <div class="flex items-center justify-between mb-2">
                    <span class="text-xs font-extrabold text-slate-900">Monday - Friday (Full Day)</span>
                    <span class="bg-emerald-100 text-emerald-800 text-[9px] font-bold px-2 py-0.5 rounded-md">Open (14 slots/day)</span>
                  </div>
                  <div class="space-y-1.5 text-[11px] text-slate-600">
                    <div class="flex items-center justify-between bg-white p-2 rounded-xl border border-slate-200/60">
                      <span class="font-semibold"><i class="fa-regular fa-sun text-amber-500 mr-1.5"></i> Morning Shift</span>
                      <span class="font-bold text-slate-900">09:00 AM - 01:00 PM</span>
                    </div>
                    <div class="flex items-center justify-between bg-purple-50/60 text-[#7C3AED] p-1.5 px-2 rounded-xl text-[10px] font-semibold">
                      <span><i class="fa-solid fa-mug-hot mr-1"></i> Lunch & Admin Break</span>
                      <span>01:00 PM - 02:00 PM (Reserved)</span>
                    </div>
                    <div class="flex items-center justify-between bg-white p-2 rounded-xl border border-slate-200/60">
                      <span class="font-semibold"><i class="fa-regular fa-moon text-indigo-500 mr-1.5"></i> Evening Shift</span>
                      <span class="font-bold text-slate-900">02:00 PM - 06:00 PM</span>
                    </div>
                  </div>
                </div>

                <!-- Shift Item: Saturday -->
                <div class="p-3 bg-slate-50 rounded-2xl border border-slate-200/80 mb-2.5">
                  <div class="flex items-center justify-between mb-1.5">
                    <span class="text-xs font-extrabold text-slate-900">Saturday (Morning Half-Day)</span>
                    <span class="bg-purple-50 text-[#7C3AED] text-[9px] font-bold px-2 py-0.5 rounded-md">Half-Day (8 slots)</span>
                  </div>
                  <div class="flex items-center justify-between bg-white p-2 rounded-xl border border-slate-200/60 text-[11px]">
                    <span class="font-semibold"><i class="fa-regular fa-sun text-amber-500 mr-1.5"></i> Clinic Shift</span>
                    <span class="font-bold text-slate-900">10:00 AM - 02:00 PM</span>
                  </div>
                </div>

                <!-- Shift Item: Sunday (Closed / On-call) -->
                <div class="p-3 bg-slate-50/70 rounded-2xl border border-slate-200/60 flex items-center justify-between opacity-75">
                  <div>
                    <span class="text-xs font-extrabold text-slate-700 block">Sunday (Clinic Closed)</span>
                    <span class="text-[10px] text-slate-400 font-medium">Emergency Telehealth Only</span>
                  </div>
                  <span class="text-[10px] text-slate-500 font-bold bg-slate-200 px-2 py-0.5 rounded-md">Off Day</span>
                </div>

              </div>

              <!-- CARD 3: SPECIAL DATE BLACKOUT OVERRIDES -->
              <div class="bg-white rounded-3xl p-4 border border-slate-100 shadow-sm mb-3">
                <div class="flex items-center justify-between mb-2">
                  <h4 class="text-xs font-extrabold text-slate-900 uppercase tracking-wider flex items-center gap-1.5">
                    <i class="fa-solid fa-umbrella-beach text-amber-500"></i> Holidays & Vacation Overrides
                  </h4>
                  <button class="text-[10px] font-bold text-[#7C3AED] hover:underline">+ Add Date</button>
                </div>
                <div class="flex flex-wrap gap-2 pt-1">
                  <div class="flex items-center gap-2 bg-slate-50 border border-slate-200 px-2.5 py-1 rounded-xl text-[10px]">
                    <span class="font-bold text-slate-800">Nov 28, 2026</span>
                    <span class="text-slate-400">Thanksgiving</span>
                    <i class="fa-solid fa-xmark text-slate-400 hover:text-red-500 cursor-pointer"></i>
                  </div>
                  <div class="flex items-center gap-2 bg-slate-50 border border-slate-200 px-2.5 py-1 rounded-xl text-[10px]">
                    <span class="font-bold text-slate-800">Dec 25, 2026</span>
                    <span class="text-slate-400">Christmas Day</span>
                    <i class="fa-solid fa-xmark text-slate-400 hover:text-red-500 cursor-pointer"></i>
                  </div>
                </div>
              </div>

            </div>

            <!-- Sticky Save Schedule Settings Button -->
            <div class="pt-3 bg-[#F5F6F8] border-t border-slate-200/60 sticky bottom-0">
              <button class="w-full py-3.5 rounded-2xl bg-[#7C3AED] hover:bg-[#6D28D9] text-white font-bold text-xs shadow-lg shadow-purple-500/30 flex items-center justify-center gap-2 transition-all cursor-pointer">
                <i class="fa-solid fa-check text-xs"></i>
                <span>Save Schedule & Clinic Settings</span>
              </button>
            </div>

          </div>
        `
      }"""

    # Replace provider_services and provider_avail
    pattern = r'provider_services:\s*\{[\s\S]*?provider_avail:\s*\{[\s\S]*?\n      \}\n\n    \};'
    replacement = new_provider_services + "\n\n" + new_provider_avail + "\n\n    };"
    html = re.sub(pattern, replacement, html)

    # 3. Update simulatorProviderNav to have nice labels and modern layout
    provider_nav_new = """          <!-- FLOATING BOTTOM NAVIGATION (Provider Mode) -->
          <nav id="simulatorProviderNav" class="floating-nav hidden">
            <div onclick="goToScreen('provider_dash')" class="nav-item active" data-nav="provider_dash">
              <i class="fa-solid fa-chart-pie text-base"></i>
              <span class="text-[9px] font-semibold mt-0.5">Overview</span>
            </div>
            <div onclick="goToScreen('provider_bookings')" class="nav-item" data-nav="provider_bookings">
              <i class="fa-solid fa-calendar-days text-base"></i>
              <span class="text-[9px] font-semibold mt-0.5">Queue</span>
            </div>
            <div onclick="goToScreen('provider_services')" class="nav-item" data-nav="provider_services">
              <i class="fa-solid fa-stethoscope text-base"></i>
              <span class="text-[9px] font-semibold mt-0.5">Services</span>
            </div>
            <div onclick="goToScreen('provider_avail')" class="nav-item" data-nav="provider_avail">
              <i class="fa-solid fa-sliders text-base"></i>
              <span class="text-[9px] font-semibold mt-0.5">Settings</span>
            </div>
          </nav>"""

    html = re.sub(r'<nav id="simulatorProviderNav" class="floating-nav hidden">[\s\S]*?</nav>', provider_nav_new, html)

    with open('app_design_preview.html', 'w', encoding='utf-8') as f:
        f.write(html)
    print("Provider services and availability settings upgraded successfully!")

if __name__ == '__main__':
    upgrade_provider_screens()
