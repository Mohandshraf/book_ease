import re

def update_html():
    with open('app_design_preview.html', 'r', encoding='utf-8') as f:
        html = f.read()

    # 1. Update Title & Meta
    html = html.replace(
        '<title>BookEase — Senior UI/UX Production Design System & 19-Screen Interactive Prototype</title>',
        '<title>BookEase — Senior UI/UX Production Design System & 25-Screen Interactive Prototype</title>'
    )

    # 2. Update Tailwind Config colors
    old_tailwind_colors = """            colors: {
            brand: {
              50: '#EFF4FF',
              100: '#DBE6FE',
              200: '#BFD3FE',
              300: '#93B4FD',
              400: '#608DFB',
              500: '#3B71FE', // Signature Electric Royal Blue from Reference
              600: '#2655EB',
              700: '#1D40CE',
              800: '#1C36A6',
              900: '#1C3182',
            },
            canvas: '#F4F7FB',
            darkText: '#0E1726',
            mutedText: '#64748B',
          },"""

    new_tailwind_colors = """            colors: {
            brand: {
              50: '#F5F3FF',
              100: '#EDE9FE',
              200: '#DDD6FE',
              300: '#C4B5FD',
              400: '#A78BFA',
              500: '#8B5CF6', // Signature Vibrant Purple from Reference
              600: '#7C3AED', // Royal Violet from Reference
              700: '#6D28D9',
              800: '#5B21B6',
              900: '#4C1D95',
            },
            canvas: '#F5F6F8', // Clean Light Gray from Reference
            darkText: '#111827',
            mutedText: '#8E95A5',
          },"""

    if old_tailwind_colors in html:
        html = html.replace(old_tailwind_colors, new_tailwind_colors)
    else:
        # regex replace colors block
        html = re.sub(
            r'brand:\s*\{[^}]+\}',
            """brand: {
              50: '#F5F3FF',
              100: '#EDE9FE',
              200: '#DDD6FE',
              300: '#C4B5FD',
              400: '#A78BFA',
              500: '#8B5CF6',
              600: '#7C3AED',
              700: '#6D28D9',
              800: '#5B21B6',
              900: '#4C1D95',
            }""",
            html
        )

    # 3. Update Shadows & Styles
    html = html.replace("rgba(59, 113, 254, 0.16)", "rgba(124, 58, 237, 0.18)")
    html = html.replace("rgba(59, 113, 254, 0.4)", "rgba(124, 58, 237, 0.4)")
    html = html.replace("rgba(59, 113, 254, 0.35)", "rgba(124, 58, 237, 0.35)")
    html = html.replace("background: rgba(59, 113, 254, 0.6);", "background: rgba(124, 58, 237, 0.6);")
    html = html.replace("background-color: #F4F7FB;", "background-color: #F5F6F8;")
    html = html.replace("background: #EFF4FF;\n      color: #3B71FE;", "background: #F5F3FF;\n      color: #7C3AED;")
    html = html.replace("background-color: #3B71FE;", "background-color: #7C3AED;")
    html = html.replace("box-shadow: 0 30px 60px -10px rgba(59, 113, 254, 0.3), 0 0 0 4px #3B71FE;", "box-shadow: 0 30px 60px -10px rgba(124, 58, 237, 0.3), 0 0 0 4px #7C3AED;")

    # 4. Craft the new medical_records screen renderer matching Image 2
    new_medical_records = """      // ==========================================
      // 16. MEDICAL RECORDS & REPORTS (PIXEL-PERFECT MATCH TO REFERENCE IMAGE 2)
      // ==========================================
      medical_records: {
        id: 'medical_records',
        num: '16',
        title: '16. Health Reports & Medical Records',
        category: 'customer',
        role: 'customer',
        hasNav: false,
        render: () => `
          <div class="phone-screen-no-nav p-5 bg-[#F5F6F8] flex flex-col justify-between h-full screen-fade">
            <div class="overflow-y-auto pr-0.5 pb-4">
              
              <!-- Top Navigation Bar (Exact Reference Image 2) -->
              <div class="flex items-center justify-between mb-4 pt-1">
                <button onclick="goToScreen('profile')" class="w-9 h-9 rounded-full bg-white border border-slate-200/80 flex items-center justify-center text-slate-700 shadow-sm hover:bg-slate-50 cursor-pointer transition-all">
                  <i class="fa-solid fa-chevron-left text-xs"></i>
                </button>
                <h3 class="text-base font-extrabold text-slate-900">Steps</h3>
                <button class="px-4 py-1.5 rounded-full bg-white border border-slate-200/80 text-slate-800 text-xs font-bold shadow-sm hover:bg-slate-50 flex items-center gap-1 cursor-pointer transition-all">
                  <i class="fa-solid fa-plus text-[10px]"></i> Add
                </button>
              </div>

              <!-- Metric Counter & Date Header (Exact Reference Image 2) -->
              <div class="flex items-center justify-between mb-3 px-1">
                <div class="flex items-center gap-2">
                  <span class="w-7 h-7 rounded-full bg-white border border-slate-200/60 flex items-center justify-center text-slate-700 text-xs shadow-xs">
                    <i class="fa-regular fa-clock text-slate-600"></i>
                  </span>
                  <div class="flex items-baseline gap-1.5">
                    <span class="text-xl font-extrabold text-slate-900 tracking-tight">4000</span>
                    <span class="text-xs text-slate-400 font-semibold">Steps</span>
                  </div>
                </div>
                <div class="flex items-center gap-1.5 text-xs text-slate-500 font-semibold">
                  <i class="fa-regular fa-clock text-slate-400 text-[11px]"></i>
                  <span>02 Jan 2024</span>
                </div>
              </div>

              <!-- Time Range Segmented Control (Exact Reference Image 2) -->
              <div class="bg-slate-200/60 p-1 rounded-full flex items-center justify-between mb-4 text-xs font-semibold text-slate-500">
                <button class="flex-1 py-1.5 text-center text-slate-500 hover:text-slate-900 transition-all">Day</button>
                <button class="flex-1 py-1.5 text-center text-slate-500 hover:text-slate-900 transition-all">week</button>
                <button class="flex-1 py-1.5 text-center bg-white text-slate-900 font-bold rounded-full shadow-sm transition-all">Month</button>
                <button class="flex-1 py-1.5 text-center text-slate-500 hover:text-slate-900 transition-all">Year</button>
              </div>

              <!-- CARD 1: MAIN BAR CHART CARD (Exact Reference Image 2) -->
              <div class="bg-white rounded-3xl p-5 border border-slate-100 shadow-sm mb-3.5">
                <div class="relative h-44 flex flex-col justify-between pt-2 pb-6">
                  
                  <!-- Horizontal Dashed Guidelines -->
                  <div class="absolute inset-x-8 top-3 border-b border-dashed border-slate-100"></div>
                  <div class="absolute inset-x-8 top-11 border-b border-dashed border-slate-100"></div>
                  <div class="absolute inset-x-8 top-20 border-b border-dashed border-slate-100"></div>
                  <div class="absolute inset-x-8 top-28 border-b border-dashed border-slate-100"></div>
                  <div class="absolute inset-x-8 top-36 border-b border-slate-100"></div>

                  <!-- Y-Axis + Bars Container -->
                  <div class="flex items-stretch h-36 relative z-10">
                    
                    <!-- Y-Axis Labels -->
                    <div class="w-7 flex flex-col justify-between text-[11px] font-semibold text-slate-400 pb-1">
                      <span>4k</span>
                      <span>3k</span>
                      <span>2k</span>
                      <span>1k</span>
                      <span>0</span>
                    </div>

                    <!-- 7 Weekday Bars -->
                    <div class="flex-1 grid grid-cols-7 gap-2 items-end px-2">
                      
                      <!-- Mon (Gray bar) -->
                      <div class="flex flex-col items-center gap-1.5 h-full justify-end">
                        <div class="w-full bg-slate-100 rounded-xl" style="height: 75%;"></div>
                      </div>

                      <!-- Tues (Gray bar) -->
                      <div class="flex flex-col items-center gap-1.5 h-full justify-end">
                        <div class="w-full bg-slate-100 rounded-xl" style="height: 42%;"></div>
                      </div>

                      <!-- Wed (Gray bar) -->
                      <div class="flex flex-col items-center gap-1.5 h-full justify-end">
                        <div class="w-full bg-slate-100 rounded-xl" style="height: 65%;"></div>
                      </div>

                      <!-- Thurs (ACTIVE PURPLE BAR from Reference Image 2) -->
                      <div class="flex flex-col items-center gap-1.5 h-full justify-end">
                        <div class="w-full bg-[#8B5CF6] rounded-xl shadow-md shadow-purple-500/30" style="height: 98%;"></div>
                      </div>

                      <!-- Fri (Gray bar) -->
                      <div class="flex flex-col items-center gap-1.5 h-full justify-end">
                        <div class="w-full bg-slate-100 rounded-xl" style="height: 48%;"></div>
                      </div>

                      <!-- Sat (Gray bar) -->
                      <div class="flex flex-col items-center gap-1.5 h-full justify-end">
                        <div class="w-full bg-slate-100 rounded-xl" style="height: 68%;"></div>
                      </div>

                      <!-- Sun (Gray bar) -->
                      <div class="flex flex-col items-center gap-1.5 h-full justify-end">
                        <div class="w-full bg-slate-100 rounded-xl" style="height: 38%;"></div>
                      </div>

                    </div>
                  </div>

                  <!-- X-Axis Labels -->
                  <div class="flex items-center pl-7 pr-2 justify-between text-[10px] font-semibold text-slate-400 pt-1">
                    <span class="flex-1 text-center">Mon</span>
                    <span class="flex-1 text-center">Tues</span>
                    <span class="flex-1 text-center">Wed</span>
                    <span class="flex-1 text-center font-bold text-slate-800">Thurs</span>
                    <span class="flex-1 text-center">Fri</span>
                    <span class="flex-1 text-center">Sat</span>
                    <span class="flex-1 text-center">Sun</span>
                  </div>

                </div>
              </div>

              <!-- CARD 2: DAY STREAK CARD (Exact Reference Image 2) -->
              <div class="bg-white rounded-3xl p-4 border border-slate-100 shadow-sm mb-3.5">
                <!-- Header -->
                <div class="flex items-center gap-2 mb-3">
                  <div class="w-7 h-7 rounded-lg bg-slate-100 flex items-center justify-center text-slate-700 text-xs">
                    <i class="fa-regular fa-calendar-check"></i>
                  </div>
                  <h4 class="text-xs font-extrabold text-slate-900">Day Streak</h4>
                </div>

                <!-- Day Names -->
                <div class="grid grid-cols-7 gap-1 text-center text-[10px] font-semibold text-slate-400 mb-2">
                  <span>Mon</span>
                  <span>Tues</span>
                  <span>Wed</span>
                  <span>Thurs</span>
                  <span>Fri</span>
                  <span>Sat</span>
                  <span>Sun</span>
                </div>

                <!-- Circular Streak Badges (Purple checked for Mon-Thurs, Gray for Fri-Sun) -->
                <div class="grid grid-cols-7 gap-1 text-center mb-3">
                  <div class="flex justify-center">
                    <span class="w-7 h-7 rounded-full bg-[#8B5CF6] text-white flex items-center justify-center text-[10px] shadow-sm"><i class="fa-solid fa-check"></i></span>
                  </div>
                  <div class="flex justify-center">
                    <span class="w-7 h-7 rounded-full bg-[#8B5CF6] text-white flex items-center justify-center text-[10px] shadow-sm"><i class="fa-solid fa-check"></i></span>
                  </div>
                  <div class="flex justify-center">
                    <span class="w-7 h-7 rounded-full bg-[#8B5CF6] text-white flex items-center justify-center text-[10px] shadow-sm"><i class="fa-solid fa-check"></i></span>
                  </div>
                  <div class="flex justify-center">
                    <span class="w-7 h-7 rounded-full bg-[#8B5CF6] text-white flex items-center justify-center text-[10px] shadow-sm"><i class="fa-solid fa-check"></i></span>
                  </div>
                  <div class="flex justify-center">
                    <span class="w-7 h-7 rounded-full bg-slate-100 flex items-center justify-center"></span>
                  </div>
                  <div class="flex justify-center">
                    <span class="w-7 h-7 rounded-full bg-slate-100 flex items-center justify-center"></span>
                  </div>
                  <div class="flex justify-center">
                    <span class="w-7 h-7 rounded-full bg-slate-100 flex items-center justify-center"></span>
                  </div>
                </div>

                <!-- Streak Motivational Footer -->
                <p class="text-center text-[11px] text-slate-500 font-medium">Amazing streak! keep going everyday champ</p>
              </div>

              <!-- CARD 3: TIME OF THE DAY TIMELINE CARD (Exact Reference Image 2) -->
              <div class="bg-white rounded-3xl p-4 border border-slate-100 shadow-sm mb-4">
                <!-- Top Row -->
                <div class="flex items-center justify-between mb-3">
                  <div>
                    <div class="flex items-center gap-1.5 text-[11px] font-semibold text-slate-500 mb-0.5">
                      <i class="fa-regular fa-clock text-slate-400"></i>
                      <span>Time of the day</span>
                    </div>
                    <div class="flex items-baseline gap-1">
                      <span class="text-sm font-extrabold text-slate-900">4000</span>
                      <span class="text-[10px] text-slate-400 font-medium">Steps</span>
                    </div>
                  </div>
                  <div class="flex items-center gap-1.5 text-xs font-bold text-[#7C3AED]">
                    <span class="w-2 h-2 rounded-full bg-[#7C3AED]"></span>
                    <span>Healthy</span>
                  </div>
                </div>

                <!-- Timeline Horizontal Blocks with Active Pin (at 17.5) -->
                <div class="relative pt-3 pb-1">
                  
                  <!-- Active Tooltip Indicator Arrow pointing to 17.5 -->
                  <div class="absolute top-0 left-[26%] -translate-x-1/2 flex flex-col items-center">
                    <span class="w-3 h-1.5 bg-[#7C3AED] rounded-t-sm"></span>
                    <i class="fa-solid fa-caret-down text-[#7C3AED] text-xs -mt-1"></i>
                  </div>

                  <!-- Horizontal Rounded Blocks -->
                  <div class="grid grid-cols-9 gap-1.5 items-center mb-1.5">
                    <div class="h-3 bg-slate-100 rounded-sm"></div>
                    <div class="h-3 bg-slate-100 rounded-sm"></div>
                    <div class="h-3 bg-[#7C3AED] rounded-sm shadow-sm"></div>
                    <div class="h-3 bg-slate-100 rounded-sm"></div>
                    <div class="h-3 bg-slate-100 rounded-sm"></div>
                    <div class="h-3 bg-slate-100 rounded-sm"></div>
                    <div class="h-3 bg-slate-100 rounded-sm"></div>
                    <div class="h-3 bg-slate-100 rounded-sm"></div>
                    <div class="h-3 bg-slate-100 rounded-sm"></div>
                  </div>

                  <!-- Timeline Numbers Below -->
                  <div class="grid grid-cols-9 gap-1 text-center text-[9px] font-semibold text-slate-400">
                    <span>15</span>
                    <span>16</span>
                    <span class="font-bold text-[#7C3AED]">17.5</span>
                    <span>20</span>
                    <span>30</span>
                    <span>35</span>
                    <span>39</span>
                    <span>40</span>
                    <span>45</span>
                  </div>
                </div>
              </div>

              <!-- ========================================================= -->
              <!-- SUB-SECTION: CLINICAL LAB TEST REPORTS & PRESCRIPTIONS     -->
              <!-- ========================================================= -->
              <div class="mb-3">
                <div class="flex items-center justify-between mb-2 px-1">
                  <h4 class="text-xs font-extrabold text-slate-900 uppercase tracking-wider flex items-center gap-1.5">
                    <span class="w-2 h-2 rounded-full bg-[#7C3AED]"></span> Medical Lab Tests & Records
                  </h4>
                  <span class="text-[10px] font-bold text-[#7C3AED] cursor-pointer hover:underline">View All (6)</span>
                </div>

                <!-- Filter Pills -->
                <div class="flex gap-1.5 overflow-x-auto pb-2 mb-3 scrollbar-none">
                  <button class="px-3 py-1.5 rounded-xl bg-[#7C3AED] text-white text-[11px] font-bold shadow-sm shadow-purple-500/20 whitespace-nowrap">All (14)</button>
                  <button class="px-3 py-1.5 rounded-xl bg-white border border-slate-200 text-slate-600 text-[11px] font-semibold hover:border-purple-500 whitespace-nowrap">🧪 Lab Tests (6)</button>
                  <button class="px-3 py-1.5 rounded-xl bg-white border border-slate-200 text-slate-600 text-[11px] font-semibold hover:border-purple-500 whitespace-nowrap">💊 Prescriptions (5)</button>
                  <button class="px-3 py-1.5 rounded-xl bg-white border border-slate-200 text-slate-600 text-[11px] font-semibold hover:border-purple-500 whitespace-nowrap">🩻 Scans (3)</button>
                </div>

                <!-- Lab Card 1: CMP Panel -->
                <div class="bg-white rounded-3xl p-4 border border-slate-100 shadow-sm mb-3">
                  <div class="flex items-start justify-between mb-2">
                    <div class="flex items-center gap-3">
                      <div class="w-10 h-10 rounded-2xl bg-purple-50 text-[#7C3AED] flex items-center justify-center text-sm font-bold shrink-0">
                        <i class="fa-solid fa-vial"></i>
                      </div>
                      <div>
                        <h5 class="text-xs font-bold text-slate-900">Comprehensive Metabolic Panel (CMP)</h5>
                        <p class="text-[10px] text-slate-400">Quest Diagnostics • Dr. Sarah Jenkins</p>
                      </div>
                    </div>
                    <span class="bg-emerald-50 text-emerald-600 border border-emerald-100 text-[9px] font-bold px-2 py-0.5 rounded-full">Normal</span>
                  </div>

                  <!-- Biomarkers Grid -->
                  <div class="grid grid-cols-3 gap-1.5 my-2.5 p-2 bg-slate-50 rounded-2xl text-center">
                    <div>
                      <span class="text-[9px] text-slate-400 block font-medium">Glucose</span>
                      <span class="text-[11px] font-bold text-slate-800">92 mg/dL</span>
                    </div>
                    <div>
                      <span class="text-[9px] text-slate-400 block font-medium">Cholesterol</span>
                      <span class="text-[11px] font-bold text-slate-800">178 mg/dL</span>
                    </div>
                    <div>
                      <span class="text-[9px] text-slate-400 block font-medium">Creatinine</span>
                      <span class="text-[11px] font-bold text-slate-800">0.9 mg/dL</span>
                    </div>
                  </div>

                  <div class="flex items-center justify-between pt-2 border-t border-slate-100 text-[11px]">
                    <span class="text-slate-400 text-[10px]"><i class="fa-regular fa-clock"></i> Aug 22, 2026</span>
                    <div class="flex gap-2">
                      <button class="px-2.5 py-1 rounded-xl bg-slate-100 hover:bg-slate-200 text-slate-700 font-bold text-[10px] flex items-center gap-1"><i class="fa-solid fa-share-nodes"></i> Share</button>
                      <button class="px-2.5 py-1 rounded-xl bg-[#7C3AED] hover:bg-[#6D28D9] text-white font-bold text-[10px] flex items-center gap-1 shadow-sm shadow-purple-500/20"><i class="fa-solid fa-file-pdf"></i> PDF</button>
                    </div>
                  </div>
                </div>

                <!-- Lab Card 2: Digital Prescription Rx -->
                <div class="bg-white rounded-3xl p-4 border border-slate-100 shadow-sm mb-3">
                  <div class="flex items-start justify-between mb-2">
                    <div class="flex items-center gap-3">
                      <div class="w-10 h-10 rounded-2xl bg-amber-50 text-amber-600 flex items-center justify-center text-sm font-bold shrink-0">
                        <i class="fa-solid fa-pills"></i>
                      </div>
                      <div>
                        <div class="flex items-center gap-1.5">
                          <h5 class="text-xs font-bold text-slate-900">Amoxicillin 500mg</h5>
                          <span class="bg-amber-100 text-amber-800 text-[9px] font-bold px-1.5 py-0.2 rounded">Rx Active</span>
                        </div>
                        <p class="text-[10px] text-slate-400">1 capsule twice daily with meals • 4 days left</p>
                      </div>
                    </div>
                  </div>
                  <div class="flex items-center justify-between pt-2.5 border-t border-slate-100 mt-2">
                    <span class="text-[10px] text-slate-500 font-medium">Refills remaining: <b class="text-slate-800">2</b></span>
                    <button class="px-3 py-1 rounded-xl bg-[#7C3AED] hover:bg-[#6D28D9] text-white font-bold text-[10px] shadow-sm shadow-purple-500/20 flex items-center gap-1">
                      <i class="fa-solid fa-repeat"></i> Request Refill
                    </button>
                  </div>
                </div>

                <!-- Lab Card 3: Radiology Imaging -->
                <div class="bg-white rounded-3xl p-4 border border-slate-100 shadow-sm flex items-center justify-between">
                  <div class="flex items-center gap-3">
                    <div class="w-10 h-10 rounded-2xl bg-purple-50 text-[#7C3AED] flex items-center justify-center text-sm font-bold shrink-0">
                      <i class="fa-solid fa-x-ray"></i>
                    </div>
                    <div>
                      <h5 class="text-xs font-bold text-slate-900">Chest Digital X-Ray (2 Views)</h5>
                      <p class="text-[10px] text-slate-400">St. Jude Medical Imaging • Clear findings</p>
                    </div>
                  </div>
                  <button class="px-2.5 py-1.5 rounded-xl bg-purple-50 hover:bg-purple-100 text-[#7C3AED] font-bold text-[10px] flex items-center gap-1">
                    <i class="fa-solid fa-expand"></i> View Scan
                  </button>
                </div>

              </div>

            </div>

            <!-- Sticky Upload Record Button -->
            <div class="pt-3 bg-[#F5F6F8] border-t border-slate-200/60 sticky bottom-0">
              <button class="w-full py-3.5 rounded-2xl bg-[#7C3AED] hover:bg-[#6D28D9] text-white font-bold text-xs shadow-lg shadow-purple-500/30 flex items-center justify-center gap-2 transition-all cursor-pointer">
                <i class="fa-solid fa-plus text-xs"></i>
                <span>Upload New Medical Document / Scan</span>
              </button>
            </div>

          </div>
        `
      },"""

    # Replace medical_records definition
    pattern = r'medical_records:\s*\{[\s\S]*?family_members:\s*\{'
    html = re.sub(pattern, new_medical_records + "\n\n      // ==========================================\n      // 17. FAMILY MEMBERS & DEPENDENTS\n      // ==========================================\n      family_members: {", html)

    # 5. Make sure family_members uses the rich purple theme matching screenshot 1
    # Replace blue elements in family_members with purple
    # Let's replace colors globally for the primary brand palette across all screens:
    # bg-blue-600 -> bg-purple-600 (or #7C3AED)
    # text-blue-600 -> text-purple-600 (or #7C3AED)
    # hover:bg-blue-700 -> hover:bg-purple-700
    # shadow-blue-500 -> shadow-purple-500
    # border-blue-600 -> border-purple-600
    # bg-blue-50 -> bg-purple-50
    # text-blue-500 -> text-purple-500
    # text-blue-400 -> text-purple-400
    # from-blue-600 to-indigo-600 -> from-purple-600 to-indigo-600
    # from-blue-600 to-indigo-900 -> from-purple-700 to-indigo-950

    html = html.replace('from-blue-600 to-indigo-600', 'from-purple-600 to-indigo-600')
    html = html.replace('from-blue-600 to-indigo-900', 'from-purple-700 to-indigo-950')
    html = html.replace('bg-blue-600', 'bg-purple-600')
    html = html.replace('hover:bg-blue-700', 'hover:bg-purple-700')
    html = html.replace('text-blue-600', 'text-purple-600')
    html = html.replace('text-blue-500', 'text-purple-500')
    html = html.replace('text-blue-400', 'text-purple-400')
    html = html.replace('text-blue-300', 'text-purple-300')
    html = html.replace('text-blue-100', 'text-purple-100')
    html = html.replace('border-blue-600', 'border-purple-600')
    html = html.replace('border-blue-500', 'border-purple-500')
    html = html.replace('border-blue-100', 'border-purple-100')
    html = html.replace('bg-blue-50', 'bg-purple-50')
    html = html.replace('hover:bg-blue-100', 'hover:bg-purple-100')
    html = html.replace('shadow-blue-500', 'shadow-purple-500')
    html = html.replace('bg-blue-500', 'bg-purple-500')
    html = html.replace('focus:border-blue-600', 'focus:border-purple-600')

    # Update bottom nav in simulator
    html = html.replace('data-nav="home">\n              <i class="fa-solid fa-house text-lg"></i>', 'data-nav="home">\n              <i class="fa-solid fa-house text-lg"></i>\n              <span class="text-[9px] font-bold mt-0.5">Home</span>')
    html = html.replace('data-nav="discover">\n              <i class="fa-solid fa-compass text-lg"></i>', 'data-nav="discover">\n              <i class="fa-solid fa-compass text-lg"></i>\n              <span class="text-[9px] font-bold mt-0.5">Discover</span>')
    html = html.replace('data-nav="bookings">\n              <i class="fa-solid fa-calendar-check text-lg"></i>', 'data-nav="bookings">\n              <i class="fa-solid fa-calendar-check text-lg"></i>\n              <span class="text-[9px] font-bold mt-0.5">Bookings</span>')

    with open('app_design_preview.html', 'w', encoding='utf-8') as f:
        f.write(html)
    print("Successfully updated app_design_preview.html with signature purple theme and exact Reference Image 2 Steps & Reports UI!")

if __name__ == '__main__':
    update_html()
