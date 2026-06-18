const std = @import("std");

pub fn Vma(comptime vk: type) type {
    return struct {
        /// Represents main object of this library initialized.
        ///
        /// Fill structure #VmaAllocatorCreateInfo and call function vmaCreateAllocator() to create it.
        /// Call function vmaDestroyAllocator() to destroy it.
        ///
        /// It is recommended to create just one object of this type per `VkDevice` object,
        /// right after Vulkan is initialized and keep it alive until before Vulkan device is destroyed.
        pub const Allocator = enum(usize) { null_handle, _ };

        /// Represents custom memory pool
        ///
        /// Fill structure VmaPoolCreateInfo and call function vmaCreatePool() to create it.
        /// Call function vmaDestroyPool() to destroy it.
        ///
        /// For more information see [Custom memory pools](@ref choosing_memory_type_custom_memory_pools).
        pub const Pool = enum(usize) { null_handle, _ };

        /// Represents single memory allocation.
        ///
        /// It may be either dedicated block of `VkDeviceMemory` or a specific region of a bigger block of this type
        /// plus unique offset.
        ///
        /// There are multiple ways to create such object.
        /// You need to fill structure VmaAllocationCreateInfo.
        /// For more information see [Choosing memory type](@ref choosing_memory_type).
        ///
        /// Although the library provides convenience functions that create Vulkan buffer or image,
        /// allocate memory for it and bind them together,
        /// binding of the allocation to a buffer or an image is out of scope of the allocation itself.
        /// Allocation object can exist without buffer/image bound,
        /// binding can be done manually by the user, and destruction of it can be done
        /// independently of destruction of the allocation.
        ///
        /// The object also remembers its size and some other information.
        /// To retrieve this information, use function vmaGetAllocationInfo() and inspect
        /// returned structure VmaAllocationInfo.
        pub const Allocation = enum(usize) { null_handle, _ };

        /// An opaque object that represents started defragmentation process.
        ///
        /// Fill structure #VmaDefragmentationInfo and call function vmaBeginDefragmentation() to create it.
        /// Call function vmaEndDefragmentation() to destroy it.
        pub const DefragmentationContext = enum(usize) { null_handle, _ };

        /// Represents single memory allocation done inside VmaVirtualBlock.
        ///
        /// Use it as a unique identifier to virtual allocation within the single block.
        ///
        /// Use value `VK_NULL_HANDLE` to represent a null/invalid allocation.
        pub const VirtualAllocation = enum(u64) { null_handle, _ };

        /// Handle to a virtual block object that allows to use core allocation algorithm without allocating any real GPU memory.
        ///
        /// Fill in #VmaVirtualBlockCreateInfo structure and use vmaCreateVirtualBlock() to create it. Use vmaDestroyVirtualBlock() to destroy it.
        /// For more information, see documentation chapter \ref virtual_allocator.
        ///
        /// This object is not thread-safe - should not be used from multiple threads simultaneously, must be synchronized externally.
        pub const VirtualBlock = enum(usize) { null_handle, _ };

        /// Set of callbacks that the library will call for vkAllocateMemory and vkFreeMemory.
        ///
        /// Provided for informative purpose, e.g. to gather statistics about number of allocations or total amount of memory allocated in Vulkan.
        ///
        /// Used in VmaAllocatorCreateInfo::pDeviceMemoryCallbacks.
        pub const DeviceMemoryCallbacks = extern struct {
            /// Optional, can be null.
            pfnAllocate: PfnAllocateDeviceMemoryFunction = null,
            /// Optional, can be null.
            pfnFree: PfnFreeDeviceMemoryFunction = null,
            /// Optional, can be null.
            pUserData: ?*anyopaque = null,
        };
        /// Pointers to some Vulkan functions - a subset used by the library.
        ///
        /// Used in VmaAllocatorCreateInfo::pVulkanFunctions.
        pub const VulkanFunctions = extern struct {
            /// Required when using VMA_DYNAMIC_VULKAN_FUNCTIONS.
            getInstanceProcAddr: vk.Command.getInstanceProcAddr.GetPtrType() = null,
            /// Required when using VMA_DYNAMIC_VULKAN_FUNCTIONS.
            getDeviceProcAddr: vk.Command.getDeviceProcAddr.GetPtrType() = null,

            getPhysicalDeviceProperties: vk.Command.getPhysicalDeviceProperties.GetPtrType(),
            getPhysicalDeviceMemoryProperties: vk.Command.getPhysicalDeviceMemoryProperties.GetPtrType(),
            allocateMemory: vk.Command.allocateMemory.GetPtrType(),
            freeMemory: vk.Command.freeMemory.GetPtrType(),
            mapMemory: vk.Command.mapMemory.GetPtrType(),
            unmapMemory: vk.Command.unmapMemory.GetPtrType(),
            flushMappedMemoryRanges: vk.Command.flushMappedMemoryRanges.GetPtrType(),
            invalidateMappedMemoryRanges: vk.Command.invalidateMappedMemoryRanges.GetPtrType(),
            bindBufferMemory: vk.Command.bindBufferMemory.GetPtrType(),
            bindImageMemory: vk.Command.bindImageMemory.GetPtrType(),
            getBufferMemoryRequirements: vk.Command.getBufferMemoryRequirements.GetPtrType(),
            getImageMemoryRequirements: vk.Command.getImageMemoryRequirements.GetPtrType(),
            createBuffer: vk.Command.createBuffer.GetPtrType(),
            destroyBuffer: vk.Command.destroyBuffer.GetPtrType(),
            createImage: vk.Command.createImage.GetPtrType(),
            destroyImage: vk.Command.destroyImage.GetPtrType(),
            cmdCopyBuffer: vk.Command.cmdCopyBuffer.GetPtrType(),
            /// Fetch "vkGetBufferMemoryRequirements2" on Vulkan >= 1.1, fetch "vkGetBufferMemoryRequirements2KHR" when using VK_KHR_dedicated_allocation extension.
            getBufferMemoryRequirements2KHR: vk.Command.getBufferMemoryRequirements2KHR.GetPtrType() = null,
            /// Fetch "vkGetImageMemoryRequirements2" on Vulkan >= 1.1, fetch "vkGetImageMemoryRequirements2KHR" when using VK_KHR_dedicated_allocation extension.
            getImageMemoryRequirements2KHR: vk.Command.getImageMemoryRequirements2KHR.GetPtrType() = null,
            /// Fetch "vkBindBufferMemory2" on Vulkan >= 1.1, fetch "vkBindBufferMemory2KHR" when using VK_KHR_bind_memory2 extension.
            bindBufferMemory2KHR: vk.Command.bindBufferMemory2KHR.GetPtrType() = null,
            /// Fetch "vkBindImageMemory2" on Vulkan >= 1.1, fetch "vkBindImageMemory2KHR" when using VK_KHR_bind_memory2 extension.
            bindImageMemory2KHR: vk.Command.bindImageMemory2KHR.GetPtrType() = null,
            /// Fetch from "vkGetDeviceBufferMemoryRequirements" on Vulkan >= 1.3, but you can also fetch it from "vkGetDeviceBufferMemoryRequirementsKHR" if you enabled extension VK_KHR_maintenance4.
            getDeviceBufferMemoryRequirements: vk.Command.getDeviceBufferMemoryRequirements.GetPtrType() = null,
            /// Fetch from "vkGetDeviceImageMemoryRequirements" on Vulkan >= 1.3, but you can also fetch it from "vkGetDeviceImageMemoryRequirementsKHR" if you enabled extension VK_KHR_maintenance4.
            getDeviceImageMemoryRequirements: vk.Command.getDeviceImageMemoryRequirements.GetPtrType() = null,
            getMemoryWin32HandleKHR: vk.Command.getMemoryWin32HandleKHR.GetPtrType(),
        };
        /// Description of a Allocator to be created.
        pub const AllocatorCreateInfo = extern struct {
            /// Flags for created allocator. Use VmaAllocatorCreateFlagBits enum.
            flags: AllocatorCreateFlags = .{},
            /// Vulkan physical device.
            physicalDevice: vk.PhysicalDevice,
            /// Vulkan device.
            device: vk.Device,
            /// Preferred size of a single VkDeviceMemory block to be allocated from large heaps > 1 GiB. Optional.
            preferredLargeHeapBlockSize: vk.DeviceSize = 0,
            /// Custom CPU memory allocation callbacks. Optional.
            pAllocationCallbacks: ?*const vk.AllocationCallbacks = null,
            /// Informative callbacks for vkAllocateMemory, vkFreeMemory. Optional.
            pDeviceMemoryCallbacks: ?*const DeviceMemoryCallbacks = null,
            /// Either null or a pointer to an array of limits on maximum number of bytes that can be allocated out of particular Vulkan memory heap.
            pHeapSizeLimit: ?[*]vk.DeviceSize = null,
            /// Pointers to Vulkan functions. Can be null.
            pVulkanFunctions: ?*const VulkanFunctions = null,
            /// Handle to Vulkan instance object.
            instance: vk.Instance,
            /// Optional. Vulkan version that the application uses.
            vulkanApiVersion: vk.ApiVersion = .{ .minor = 0 },
            /// Either null or a pointer to an array of external memory handle types for each Vulkan memory type.
            pTypeExternalMemoryHandleTypes: ?[*]vk.ExternalMemoryHandleTypeFlagsKHR = null,
        };
        /// Information about existing VmaAllocator object.
        pub const AllocatorInfo = extern struct {
            /// Handle to Vulkan instance object.
            instance: vk.Instance,
            /// Handle to Vulkan physical device object.
            physicalDevice: vk.PhysicalDevice,
            /// Handle to Vulkan device object.
            device: vk.Device,
        };
        /// Calculated statistics of memory usage e.g. in a specific memory type, heap, custom pool, or total.
        ///
        /// These are fast to calculate. See functions: vmaGetHeapBudgets(), vmaGetPoolStatistics().
        pub const Statistics = extern struct {
            /// Number of VkDeviceMemory objects - Vulkan memory blocks allocated.
            blockCount: u32,
            /// Number of VmaAllocation objects allocated.
            allocationCount: u32,
            /// Number of bytes allocated in VkDeviceMemory blocks.
            blockBytes: vk.DeviceSize,
            /// Total number of bytes occupied by all VmaAllocation objects.
            allocationBytes: vk.DeviceSize,
        };
        /// More detailed statistics than VmaStatistics.
        ///
        /// These are slower to calculate. Use for debugging purposes. See functions: vmaCalculateStatistics(), vmaCalculatePoolStatistics().
        ///
        /// Previous version of the statistics API provided averages, but they have been removed because they can be easily calculated as:
        ///
        /// ```c
        /// VkDeviceSize allocationSizeAvg = detailedStats.statistics.allocationBytes / detailedStats.statistics.allocationCount;
        /// VkDeviceSize unusedBytes = detailedStats.statistics.blockBytes - detailedStats.statistics.allocationBytes;
        /// VkDeviceSize unusedRangeSizeAvg = unusedBytes / detailedStats.unusedRangeCount;
        /// ```
        pub const DetailedStatistics = extern struct {
            /// Basic statistics.
            statistics: Statistics,
            /// Number of free ranges of memory between allocations.
            unusedRangeCount: u32,
            /// Smallest allocation size. VK_WHOLE_SIZE if there are 0 allocations.
            allocationSizeMin: vk.DeviceSize,
            /// Largest allocation size. 0 if there are 0 allocations.
            allocationSizeMax: vk.DeviceSize,
            /// Smallest empty range size. VK_WHOLE_SIZE if there are 0 empty ranges.
            unusedRangeSizeMin: vk.DeviceSize,
            ///Largest empty range size. 0 if there are 0 empty ranges.
            unusedRangeSizeMax: vk.DeviceSize,
        };
        /// General statistics from current state of the Allocator - total memory usage across all memory heaps and types.
        ///
        /// These are slower to calculate. Use for debugging purposes. See function vmaCalculateStatistics().
        pub const TotalStatistics = extern struct {
            memoryType: [vk.VK_MAX_MEMORY_TYPES]DetailedStatistics,
            memoryHeap: [vk.VK_MAX_MEMORY_HEAPS]DetailedStatistics,
            total: DetailedStatistics,
        };
        /// Statistics of current memory usage and available budget for a specific memory heap.
        ///
        /// These are fast to calculate. See function vmaGetHeapBudgets().
        pub const Budget = extern struct {
            /// Statistics fetched from the library.
            statistics: Statistics,
            /// Estimated current memory usage of the program, in bytes.
            usage: vk.DeviceSize,
            /// Estimated amount of memory available to the program, in bytes.
            budget: vk.DeviceSize,
        };
        /// Parameters of new VmaAllocation.
        ///
        /// To be used with functions like vmaCreateBuffer(), vmaCreateImage(), and many others.
        pub const AllocationCreateInfo = extern struct {
            /// Use VmaAllocationCreateFlagBits enum.
            flags: AllocationCreateFlags = .{},

            /// Intended usage of memory.
            usage: MemoryUsage = .AUTO,

            /// Flags that must be set in a Memory Type chosen for an allocation.
            requiredFlags: vk.MemoryPropertyFlags = .{},

            /// Flags that preferably should be set in a memory type chosen for an allocation.
            preferredFlags: vk.MemoryPropertyFlags = .{},

            /// Bitmask containing one bit set for every memory type acceptable for this allocation.
            memoryTypeBits: std.bit_set.Integer(32) = .empty,

            /// Pool that this allocation should be created in.
            pool: Pool = .null_handle,

            /// Custom general-purpose pointer that will be stored in VmaAllocation, can be read as VmaAllocationInfo::pUserData and changed using vmaSetAllocationUserData().
            pUserData: ?*anyopaque = null,

            /// A floating-point value between 0 and 1, indicating the priority of the allocation relative to other memory allocations.
            priority: f32 = 0,

            /// Additional minimum alignment to be used for this allocation. Can be 0.
            minAlignment: vk.DeviceSize = 0,
        };
        /// Describes parameter of created VmaPool.
        pub const PoolCreateInfo = extern struct {
            /// Vulkan memory type index to allocate this pool from.
            memoryTypeIndex: u32,
            /// Use combination of VmaPoolCreateFlagBits.
            flags: PoolCreateFlags = .{},
            /// Size of a single VkDeviceMemory block to be allocated as part of this pool, in bytes. Optional.
            blockSize: vk.DeviceSize = 0,
            /// Minimum number of blocks to be always allocated in this pool, even if they stay empty.
            minBlockCount: usize,
            /// Maximum number of blocks that can be allocated in this pool. Optional.
            maxBlockCount: usize = 0,
            /// A floating-point value between 0 and 1, indicating the priority of the allocations in this pool relative to other memory allocations.
            priority: f32 = 0,
            /// Additional minimum alignment to be used for all allocations created from this pool. Can be 0.
            minAllocationAlignment: vk.DeviceSize = 0,
            /// Additional pNext chain to be attached to VkMemoryAllocateInfo used for every allocation made by this pool. Optional.
            pMemoryAllocateNext: ?*anyopaque = null,
        };
        /// Parameters of VmaAllocation objects, that can be retrieved using function vmaGetAllocationInfo().
        ///
        /// There is also an extended version of this structure that carries additional parameters: VmaAllocationInfo2.
        pub const AllocationInfo = extern struct {
            /// Memory type index that this allocation was allocated from.
            memoryType: u32,
            /// Handle to Vulkan memory object.
            deviceMemory: vk.DeviceMemory,
            /// Offset in VkDeviceMemory object to the beginning of this allocation, in bytes. (deviceMemory, offset) pair is unique to this allocation.
            offset: vk.DeviceSize,
            /// Size of this allocation, in bytes.
            size: vk.DeviceSize,
            /// Pointer to the beginning of this allocation as mapped data.
            pMappedData: [*]u8,
            /// Custom general-purpose pointer that was passed as VmaAllocationCreateInfo::pUserData or set using vmaSetAllocationUserData().
            pUserData: ?*anyopaque = null,
            /// Custom allocation name that was set with vmaSetAllocationName().
            pName: [*:0]const u8,
        };
        /// Extended parameters of a VmaAllocation object that can be retrieved using function vmaGetAllocationInfo2().
        pub const AllocationInfo2 = extern struct {
            /// Basic parameters of the allocation.
            allocationInfo: AllocationInfo,
            /// Size of the VkDeviceMemory block that the allocation belongs to.
            blockSize: vk.DeviceSize,
            /// VK_TRUE if the allocation has dedicated memory, VK_FALSE if it was placed as part of a larger memory block.
            dedicatedMemory: vk.Bool32,
        };
        /// Parameters for defragmentation.
        ///
        /// To be used with function vmaBeginDefragmentation().
        pub const DefragmentationInfo = extern struct {
            /// Use combination of VmaDefragmentationFlagBits.
            flags: DefragmentationFlags = .{},
            /// Custom pool to be defragmented.
            pool: Pool = null,
            /// Maximum numbers of bytes that can be copied during single pass, while moving allocations to different places.
            maxBytesPerPass: vk.DeviceSize,
            /// Maximum number of allocations that can be moved during single pass to a different place.
            maxAllocationsPerPass: u32,
            /// Optional custom callback for stopping vmaBeginDefragmentation().
            pfnBreakCallback: PfnCheckDefragmentationBreakFunction = null,
            /// Optional data to pass to custom callback for stopping pass of defragmentation.
            pBreakCallbackUserData: ?*anyopaque = null,
        };
        /// Single move of an allocation to be done for defragmentation.
        pub const DefragmentationMove = extern struct {
            /// Operation to be performed on the allocation by vmaEndDefragmentationPass(). Default value is VMA_DEFRAGMENTATION_MOVE_OPERATION_COPY. You can modify it.
            operation: DefragmentationMoveOperation = .COPY,
            /// Allocation that should be moved.
            srcAllocation: Allocation,
            /// Temporary allocation pointing to destination memory that will replace srcAllocation.
            dstTmpAllocation: Allocation,
        };
        /// Parameters for incremental defragmentation steps.
        ///
        /// To be used with function vmaBeginDefragmentationPass().
        pub const DefragmentationPassMoveInfo = extern struct {
            /// Number of elements in the pMoves array.
            moveCount: u32,
            /// Array of moves to be performed by the user in the current defragmentation pass.
            pMoves: [*]DefragmentationMove,
        };
        /// Statistics returned for defragmentation process in function vmaEndDefragmentation().
        pub const DefragmentationStats = extern struct {
            /// Total number of bytes that have been copied while moving allocations to different places.
            bytesMoved: vk.DeviceSize,
            /// Total number of bytes that have been released to the system by freeing empty VkDeviceMemory objects.
            bytesFreed: vk.DeviceSize,
            /// Number of allocations that have been moved to different places.
            allocationsMoved: u32,
            /// Number of empty VkDeviceMemory objects that have been released to the system.
            deviceMemoryBlocksFreed: u32,
        };
        /// Parameters of created VmaVirtualBlock object to be passed to vmaCreateVirtualBlock().
        pub const VirtualBlockCreateInfo = extern struct {
            /// Total size of the virtual block.
            size: vk.DeviceSize,
            /// Use combination of VmaVirtualBlockCreateFlagBits.
            flags: VirtualBlockCreateFlags = .{},
            /// Custom CPU memory allocation callbacks. Optional.
            pAllocationCallbacks: ?*const vk.AllocationCallbacks = null,
        };
        /// Parameters of created virtual allocation to be passed to vmaVirtualAllocate().
        pub const VirtualAllocationCreateInfo = extern struct {
            /// Size of the allocation.
            size: vk.DeviceSize,
            /// Required alignment of the allocation. Optional.
            alignment: vk.DeviceSize,
            /// Use combination of VmaVirtualAllocationCreateFlagBits.
            flags: VirtualAllocationCreateFlags = .{},
            /// Custom pointer to be associated with the allocation. Optional.
            pUserData: ?*const anyopaque = null,
        };
        /// Parameters of an existing virtual allocation, returned by vmaGetVirtualAllocationInfo().
        pub const VirtualAllocationInfo = extern struct {
            /// Offset of the allocation.
            offset: vk.DeviceSize,
            /// Size of the allocation.
            size: vk.DeviceSize,
            /// Custom pointer associated with the allocation.
            pUserData: ?*anyopaque = null,
        };

        pub const AllocatorCreateFlagBits = enum(i32) {
            /// Allocator and all objects created from it will not be synchronized internally, so you must guarantee they are used from only one thread at a time or synchronized externally by you.
            ///
            /// Using this flag may increase performance because internal mutexes are not used.
            EXTERNALLY_SYNCHRONIZED_BIT = 1 << 0,

            /// Enables usage of VK_KHR_dedicated_allocation extension.
            ///
            /// The flag works only if VmaAllocatorCreateInfo::vulkanApiVersion == VK_API_VERSION_1_0. When it is VK_API_VERSION_1_1, the flag is ignored because the extension has been promoted to Vulkan 1.1.
            ///
            /// Using this extension will automatically allocate dedicated blocks of memory for some buffers and images instead of suballocating place for them out of bigger memory blocks (as if you explicitly used VMA_ALLOCATION_CREATE_DEDICATED_MEMORY_BIT flag) when it is recommended by the driver. It may improve performance on some GPUs.
            ///
            /// You may set this flag only if you found out that following device extensions are supported, you enabled them while creating Vulkan device passed as VmaAllocatorCreateInfo::device, and you want them to be used internally by this library:
            ///
            /// VK_KHR_get_memory_requirements2 (device extension)
            /// VK_KHR_dedicated_allocation (device extension)
            /// When this flag is set, you can experience following warnings reported by Vulkan validation layer. You can ignore them.
            ///
            /// VkBindBufferMemory(): Binding memory to buffer 0x2d but vkGetBufferMemoryRequirements() has not been called on that buffer.
            KHR_DEDICATED_ALLOCATION_BIT = 1 << 1,

            /// Enables usage of VK_KHR_bind_memory2 extension.
            ///
            /// The flag works only if VmaAllocatorCreateInfo::vulkanApiVersion == VK_API_VERSION_1_0. When it is VK_API_VERSION_1_1, the flag is ignored because the extension has been promoted to Vulkan 1.1.
            ///
            /// You may set this flag only if you found out that this device extension is supported, you enabled it while creating Vulkan device passed as VmaAllocatorCreateInfo::device, and you want it to be used internally by this library.
            ///
            /// The extension provides functions vkBindBufferMemory2KHR and vkBindImageMemory2KHR, which allow to pass a chain of pNext structures while binding. This flag is required if you use pNext parameter in vmaBindBufferMemory2() or vmaBindImageMemory2().
            KHR_BIND_MEMORY2_BIT = 1 << 2,

            /// Enables usage of VK_EXT_memory_budget extension.
            ///
            /// You may set this flag only if you found out that this device extension is supported, you enabled it while creating Vulkan device passed as VmaAllocatorCreateInfo::device, and you want it to be used internally by this library, along with another instance extension VK_KHR_get_physical_device_properties2, which is required by it (or Vulkan 1.1, where this extension is promoted).
            ///
            /// The extension provides query for current memory usage and budget, which will probably be more accurate than an estimation used by the library otherwise.
            EXT_MEMORY_BUDGET_BIT = 1 << 3,

            /// Enables usage of VK_AMD_device_coherent_memory extension.
            ///
            /// You may set this flag only if you:
            ///
            /// found out that this device extension is supported and enabled it while creating Vulkan device passed as VmaAllocatorCreateInfo::device,
            /// checked that VkPhysicalDeviceCoherentMemoryFeaturesAMD::deviceCoherentMemory is true and set it while creating the Vulkan device,
            /// want it to be used internally by this library.
            /// The extension and accompanying device feature provide access to memory types with VK_MEMORY_PROPERTY_DEVICE_COHERENT_BIT_AMD and VK_MEMORY_PROPERTY_DEVICE_UNCACHED_BIT_AMD flags. They are useful mostly for writing breadcrumb markers - a common method for debugging GPU crash/hang/TDR.
            ///
            /// When the extension is not enabled, such memory types are still enumerated, but their usage is illegal. To protect from this error, if you don't create the allocator with this flag, it will refuse to allocate any memory or create a custom pool in such memory type, returning VK_ERROR_FEATURE_NOT_PRESENT.
            AMD_DEVICE_COHERENT_MEMORY_BIT = 1 << 4,

            /// Enables usage of "buffer device address" feature, which allows you to use function vkGetBufferDeviceAddress* to get raw GPU pointer to a buffer and pass it for usage inside a shader.
            ///
            /// You may set this flag only if you:
            ///
            /// (For Vulkan version < 1.2) Found as available and enabled device extension VK_KHR_buffer_device_address. This extension is promoted to core Vulkan 1.2.
            /// Found as available and enabled device feature VkPhysicalDeviceBufferDeviceAddressFeatures::bufferDeviceAddress.
            /// When this flag is set, you can create buffers with VK_BUFFER_USAGE_SHADER_DEVICE_ADDRESS_BIT using VMA. The library automatically adds VK_MEMORY_ALLOCATE_DEVICE_ADDRESS_BIT to allocated memory blocks wherever it might be needed.
            ///
            /// For more information, see documentation chapter Enabling buffer device address.
            BUFFER_DEVICE_ADDRESS_BIT = 1 << 5,

            /// Enables usage of VK_EXT_memory_priority extension in the library.
            ///
            /// You may set this flag only if you found available and enabled this device extension, along with VkPhysicalDeviceMemoryPriorityFeaturesEXT::memoryPriority == VK_TRUE, while creating Vulkan device passed as VmaAllocatorCreateInfo::device.
            ///
            /// When this flag is used, VmaAllocationCreateInfo::priority and VmaPoolCreateInfo::priority are used to set priorities of allocated Vulkan memory. Without it, these variables are ignored.
            ///
            /// A priority must be a floating-point value between 0 and 1, indicating the priority of the allocation relative to other memory allocations. Larger values are higher priority. The granularity of the priorities is implementation-dependent. It is automatically passed to every call to vkAllocateMemory done by the library using structure VkMemoryPriorityAllocateInfoEXT. The value to be used for default priority is 0.5. For more details, see the documentation of the VK_EXT_memory_priority extension.
            EXT_MEMORY_PRIORITY_BIT = 1 << 6,

            /// Enables usage of VK_KHR_maintenance4 extension in the library.
            ///
            /// You may set this flag only if you found available and enabled this device extension, while creating Vulkan device passed as VmaAllocatorCreateInfo::device.
            KHR_MAINTENANCE4_BIT = 1 << 7,

            /// Enables usage of VK_KHR_maintenance5 extension in the library.
            ///
            /// You should set this flag if you found available and enabled this device extension, while creating Vulkan device passed as VmaAllocatorCreateInfo::device.
            KHR_MAINTENANCE5_BIT = 1 << 8,

            /// Enables usage of VK_KHR_external_memory_win32 extension in the library.
            ///
            /// You should set this flag if you found available and enabled this device extension, while creating Vulkan device passed as VmaAllocatorCreateInfo::device. For more information, see Interop with other graphics APIs.
            KHR_EXTERNAL_MEMORY_WIN32_BIT = 1 << 9,

            const Flags = AllocatorCreateFlags;
            pub const toFlags = vk.FlagBitsMixin(Flags, @This()).toFlags;
            pub const fromFlags = vk.FlagBitsMixin(Flags, @This()).fromFlags;
            pub const toInt = vk.FlagBitsMixin(Flags, @This()).toInt;
            pub const fromInt = vk.FlagBitsMixin(Flags, @This()).fromInt;
        };
        pub const AllocatorCreateFlags = packed struct(u32) {
            /// Allocator and all objects created from it will not be synchronized internally, so you must guarantee they are used from only one thread at a time or synchronized externally by you.
            ///
            /// Using this flag may increase performance because internal mutexes are not used.
            EXTERNALLY_SYNCHRONIZED_BIT: bool = false,

            /// Enables usage of VK_KHR_dedicated_allocation extension.
            ///
            /// The flag works only if VmaAllocatorCreateInfo::vulkanApiVersion == VK_API_VERSION_1_0. When it is VK_API_VERSION_1_1, the flag is ignored because the extension has been promoted to Vulkan 1.1.
            ///
            /// Using this extension will automatically allocate dedicated blocks of memory for some buffers and images instead of suballocating place for them out of bigger memory blocks (as if you explicitly used VMA_ALLOCATION_CREATE_DEDICATED_MEMORY_BIT flag) when it is recommended by the driver. It may improve performance on some GPUs.
            ///
            /// You may set this flag only if you found out that following device extensions are supported, you enabled them while creating Vulkan device passed as VmaAllocatorCreateInfo::device, and you want them to be used internally by this library:
            ///
            /// VK_KHR_get_memory_requirements2 (device extension)
            /// VK_KHR_dedicated_allocation (device extension)
            /// When this flag is set, you can experience following warnings reported by Vulkan validation layer. You can ignore them.
            ///
            /// VkBindBufferMemory(): Binding memory to buffer 0x2d but vkGetBufferMemoryRequirements() has not been called on that buffer.
            KHR_DEDICATED_ALLOCATION_BIT: bool = false,

            /// Enables usage of VK_KHR_bind_memory2 extension.
            ///
            /// The flag works only if VmaAllocatorCreateInfo::vulkanApiVersion == VK_API_VERSION_1_0. When it is VK_API_VERSION_1_1, the flag is ignored because the extension has been promoted to Vulkan 1.1.
            ///
            /// You may set this flag only if you found out that this device extension is supported, you enabled it while creating Vulkan device passed as VmaAllocatorCreateInfo::device, and you want it to be used internally by this library.
            ///
            /// The extension provides functions vkBindBufferMemory2KHR and vkBindImageMemory2KHR, which allow to pass a chain of pNext structures while binding. This flag is required if you use pNext parameter in vmaBindBufferMemory2() or vmaBindImageMemory2().
            KHR_BIND_MEMORY2_BIT: bool = false,

            /// Enables usage of VK_EXT_memory_budget extension.
            ///
            /// You may set this flag only if you found out that this device extension is supported, you enabled it while creating Vulkan device passed as VmaAllocatorCreateInfo::device, and you want it to be used internally by this library, along with another instance extension VK_KHR_get_physical_device_properties2, which is required by it (or Vulkan 1.1, where this extension is promoted).
            ///
            /// The extension provides query for current memory usage and budget, which will probably be more accurate than an estimation used by the library otherwise.
            EXT_MEMORY_BUDGET_BIT: bool = false,

            /// Enables usage of VK_AMD_device_coherent_memory extension.
            ///
            /// You may set this flag only if you:
            ///
            /// found out that this device extension is supported and enabled it while creating Vulkan device passed as VmaAllocatorCreateInfo::device,
            /// checked that VkPhysicalDeviceCoherentMemoryFeaturesAMD::deviceCoherentMemory is true and set it while creating the Vulkan device,
            /// want it to be used internally by this library.
            /// The extension and accompanying device feature provide access to memory types with VK_MEMORY_PROPERTY_DEVICE_COHERENT_BIT_AMD and VK_MEMORY_PROPERTY_DEVICE_UNCACHED_BIT_AMD flags. They are useful mostly for writing breadcrumb markers - a common method for debugging GPU crash/hang/TDR.
            ///
            /// When the extension is not enabled, such memory types are still enumerated, but their usage is illegal. To protect from this error, if you don't create the allocator with this flag, it will refuse to allocate any memory or create a custom pool in such memory type, returning VK_ERROR_FEATURE_NOT_PRESENT.
            AMD_DEVICE_COHERENT_MEMORY_BIT: bool = false,

            /// Enables usage of "buffer device address" feature, which allows you to use function vkGetBufferDeviceAddress* to get raw GPU pointer to a buffer and pass it for usage inside a shader.
            ///
            /// You may set this flag only if you:
            ///
            /// (For Vulkan version < 1.2) Found as available and enabled device extension VK_KHR_buffer_device_address. This extension is promoted to core Vulkan 1.2.
            /// Found as available and enabled device feature VkPhysicalDeviceBufferDeviceAddressFeatures::bufferDeviceAddress.
            /// When this flag is set, you can create buffers with VK_BUFFER_USAGE_SHADER_DEVICE_ADDRESS_BIT using VMA. The library automatically adds VK_MEMORY_ALLOCATE_DEVICE_ADDRESS_BIT to allocated memory blocks wherever it might be needed.
            ///
            /// For more information, see documentation chapter Enabling buffer device address.
            BUFFER_DEVICE_ADDRESS_BIT: bool = false,

            /// Enables usage of VK_EXT_memory_priority extension in the library.
            ///
            /// You may set this flag only if you found available and enabled this device extension, along with VkPhysicalDeviceMemoryPriorityFeaturesEXT::memoryPriority == VK_TRUE, while creating Vulkan device passed as VmaAllocatorCreateInfo::device.
            ///
            /// When this flag is used, VmaAllocationCreateInfo::priority and VmaPoolCreateInfo::priority are used to set priorities of allocated Vulkan memory. Without it, these variables are ignored.
            ///
            /// A priority must be a floating-point value between 0 and 1, indicating the priority of the allocation relative to other memory allocations. Larger values are higher priority. The granularity of the priorities is implementation-dependent. It is automatically passed to every call to vkAllocateMemory done by the library using structure VkMemoryPriorityAllocateInfoEXT. The value to be used for default priority is 0.5. For more details, see the documentation of the VK_EXT_memory_priority extension.
            EXT_MEMORY_PRIORITY_BIT: bool = false,

            /// Enables usage of VK_KHR_maintenance4 extension in the library.
            ///
            /// You may set this flag only if you found available and enabled this device extension, while creating Vulkan device passed as VmaAllocatorCreateInfo::device.
            KHR_MAINTENANCE4_BIT: bool = false,

            /// Enables usage of VK_KHR_maintenance5 extension in the library.
            ///
            /// You should set this flag if you found available and enabled this device extension, while creating Vulkan device passed as VmaAllocatorCreateInfo::device.
            KHR_MAINTENANCE5_BIT: bool = false,

            /// Enables usage of VK_KHR_external_memory_win32 extension in the library.
            ///
            /// You should set this flag if you found available and enabled this device extension, while creating Vulkan device passed as VmaAllocatorCreateInfo::device. For more information, see Interop with other graphics APIs.
            KHR_EXTERNAL_MEMORY_WIN32_BIT: bool = false,
            _reserved_trailing: vk.LockedInt(u22, 0) = .locked,

            const Bits = AllocatorCreateFlagBits;
            pub const toInt = vk.FlagsMixin(@This(), Bits).toInt;
            pub const fromInt = vk.FlagsMixin(@This(), Bits).fromInt;
            pub const merge = vk.FlagsMixin(@This(), Bits).merge;
            pub const intersection = vk.FlagsMixin(@This(), Bits).intersection;
            pub const negation = vk.FlagsMixin(@This(), Bits).negation;
            pub const difference = vk.FlagsMixin(@This(), Bits).difference;
            pub const toBit = vk.FlagsMixin(@This(), Bits).toBit;
            pub const fromBit = vk.FlagsMixin(@This(), Bits).fromBit;
            pub const set = vk.FlagsMixin(@This(), Bits).set;
            pub const unset = vk.FlagsMixin(@This(), Bits).unset;
        };

        pub const MemoryUsage = enum(c_int) {
            /// No intended memory usage specified. Use other members of VmaAllocationCreateInfo to specify your requirements.
            UNKNOWN = 0,

            /// Lazily allocated GPU memory having VK_MEMORY_PROPERTY_LAZILY_ALLOCATED_BIT. Exists mostly on mobile platforms. Using it on desktop PC or other GPUs with no such memory type present will fail the allocation.
            ///
            /// Usage: Memory for transient attachment images (color attachments, depth attachments etc.), created with VK_IMAGE_USAGE_TRANSIENT_ATTACHMENT_BIT.
            ///
            /// Allocations with this usage are always created as dedicated - it implies VMA_ALLOCATION_CREATE_DEDICATED_MEMORY_BIT.
            VMA_MEMORY_USAGE_GPU_LAZILY_ALLOCATED = 6,

            /// Selects best memory type automatically. This flag is recommended for most common use cases.
            ///
            /// When using this flag, if you want to map the allocation (using vmaMapMemory() or VMA_ALLOCATION_CREATE_MAPPED_BIT), you must pass one of the flags: VMA_ALLOCATION_CREATE_HOST_ACCESS_SEQUENTIAL_WRITE_BIT or VMA_ALLOCATION_CREATE_HOST_ACCESS_RANDOM_BIT in VmaAllocationCreateInfo::flags.
            ///
            /// It can be used only with functions that let the library know VkBufferCreateInfo or VkImageCreateInfo, e.g. vmaCreateBuffer(), vmaCreateImage(), vmaFindMemoryTypeIndexForBufferInfo(), vmaFindMemoryTypeIndexForImageInfo() and not with generic memory allocation functions.
            VMA_MEMORY_USAGE_AUTO = 7,

            /// Selects best memory type automatically with preference for GPU (device) memory.
            ///
            /// When using this flag, if you want to map the allocation (using vmaMapMemory() or VMA_ALLOCATION_CREATE_MAPPED_BIT), you must pass one of the flags: VMA_ALLOCATION_CREATE_HOST_ACCESS_SEQUENTIAL_WRITE_BIT or VMA_ALLOCATION_CREATE_HOST_ACCESS_RANDOM_BIT in VmaAllocationCreateInfo::flags.
            ///
            /// It can be used only with functions that let the library know VkBufferCreateInfo or VkImageCreateInfo, e.g. vmaCreateBuffer(), vmaCreateImage(), vmaFindMemoryTypeIndexForBufferInfo(), vmaFindMemoryTypeIndexForImageInfo() and not with generic memory allocation functions.
            VMA_MEMORY_USAGE_AUTO_PREFER_DEVICE = 8,

            /// Selects best memory type automatically with preference for CPU (host) memory.
            ///
            /// When using this flag, if you want to map the allocation (using vmaMapMemory() or VMA_ALLOCATION_CREATE_MAPPED_BIT), you must pass one of the flags: VMA_ALLOCATION_CREATE_HOST_ACCESS_SEQUENTIAL_WRITE_BIT or VMA_ALLOCATION_CREATE_HOST_ACCESS_RANDOM_BIT in VmaAllocationCreateInfo::flags.
            ///
            /// It can be used only with functions that let the library know VkBufferCreateInfo or VkImageCreateInfo, e.g. vmaCreateBuffer(), vmaCreateImage(), vmaFindMemoryTypeIndexForBufferInfo(), vmaFindMemoryTypeIndexForImageInfo() and not with generic memory allocation functions.
            VMA_MEMORY_USAGE_AUTO_PREFER_HOST = 9,
        };

        pub const AllocationCreateFlagBits = enum(i32) {
            /// Set this flag if the allocation should have its own memory block.
            ///
            /// Use it for special, big resources, like fullscreen images used as attachments.
            ///
            /// If you use this flag while creating a buffer or an image, VkMemoryDedicatedAllocateInfo structure is applied if possible.
            DEDICATED_MEMORY = 1 << 0,

            /// Set this flag to only try to allocate from existing VkDeviceMemory blocks and never create new such block.
            ///
            /// If new allocation cannot be placed in any of the existing blocks, allocation fails with VK_ERROR_OUT_OF_DEVICE_MEMORY error.
            ///
            /// You should not use VMA_ALLOCATION_CREATE_DEDICATED_MEMORY_BIT and VMA_ALLOCATION_CREATE_NEVER_ALLOCATE_BIT at the same time. It makes no sense.
            NEVER_ALLOCATE = 1 << 1,

            /// Set this flag to use a memory that will be persistently mapped and retrieve pointer to it.
            ///
            /// Pointer to mapped memory will be returned through VmaAllocationInfo::pMappedData.
            ///
            /// It is valid to use this flag for allocation made from memory type that is not HOST_VISIBLE. This flag is then ignored and memory is not mapped. This is useful if you need an allocation that is efficient to use on GPU (DEVICE_LOCAL) and still want to map it directly if possible on platforms that support it (e.g. Intel GPU).
            CREATE_MAPPED = 1 << 2,

            /// Allocation will be created from upper stack in a double stack pool.
            ///
            /// This flag is only allowed for custom pools created with VMA_POOL_CREATE_LINEAR_ALGORITHM_BIT flag.
            UPPER_ADDRESS = 1 << 4,

            /// Create both buffer/image and allocation, but don't bind them together. It is useful when you want to bind yourself to do some more advanced binding, e.g. using some extensions. The flag is meaningful only with functions that bind by default: vmaCreateBuffer(), vmaCreateImage(). Otherwise it is ignored.
            ///
            /// If you want to make sure the new buffer/image is not tied to the new memory allocation through VkMemoryDedicatedAllocateInfoKHR structure in case the allocation ends up in its own memory block, use also flag VMA_ALLOCATION_CREATE_CAN_ALIAS_BIT.
            DONT_BIND = 1 << 5,

            /// Create allocation only if additional device memory required for it, if any, won't exceed memory budget. Otherwise return VK_ERROR_OUT_OF_DEVICE_MEMORY.
            WITHIN_BUDGET = 1 << 6,

            /// Set this flag if the allocated memory will have aliasing resources.
            ///
            /// Usage of this flag prevents supplying VkMemoryDedicatedAllocateInfoKHR when VMA_ALLOCATION_CREATE_DEDICATED_MEMORY_BIT is specified. Otherwise created dedicated memory will not be suitable for aliasing resources, resulting in Vulkan Validation Layer errors.
            CAN_ALIAS = 1 << 7,

            /// Requests possibility to map the allocation (using vmaMapMemory() or VMA_ALLOCATION_CREATE_MAPPED_BIT).
            ///
            /// If you use VMA_MEMORY_USAGE_AUTO or other VMA_MEMORY_USAGE_AUTO* value, you must use this flag to be able to map the allocation. Otherwise, mapping is incorrect.
            /// If you use other value of VmaMemoryUsage, this flag is ignored and mapping is always possible in memory types that are HOST_VISIBLE. This includes allocations created in Custom memory pools.
            /// Declares that mapped memory will only be written sequentially, e.g. using memcpy() or a loop writing number-by-number, never read or accessed randomly, so a memory type can be selected that is uncached and write-combined.
            ///
            /// Warning
            /// Violating this declaration may work correctly, but will likely be very slow. Watch out for implicit reads introduced by doing e.g. pMappedData[i] += x; Better prepare your data in a local variable and memcpy() it to the mapped pointer all at once.
            HOST_ACCESS_SEQUENTIAL_WRITE = 1 << 8,
            /// Requests possibility to map the allocation (using vmaMapMemory() or VMA_ALLOCATION_CREATE_MAPPED_BIT).
            ///
            /// If you use VMA_MEMORY_USAGE_AUTO or other VMA_MEMORY_USAGE_AUTO* value, you must use this flag to be able to map the allocation. Otherwise, mapping is incorrect.
            /// If you use other value of VmaMemoryUsage, this flag is ignored and mapping is always possible in memory types that are HOST_VISIBLE. This includes allocations created in Custom memory pools.
            /// Declares that mapped memory can be read, written, and accessed in random order, so a HOST_CACHED memory type is preferred.
            HOST_ACCESS_RANDOM = 1 << 9,

            /// Together with VMA_ALLOCATION_CREATE_HOST_ACCESS_SEQUENTIAL_WRITE_BIT or VMA_ALLOCATION_CREATE_HOST_ACCESS_RANDOM_BIT, it says that despite request for host access, a not-HOST_VISIBLE memory type can be selected if it may improve performance.
            ///
            /// By using this flag, you declare that you will check if the allocation ended up in a HOST_VISIBLE memory type (e.g. using vmaGetAllocationMemoryProperties()) and if not, you will create some "staging" buffer and issue an explicit transfer to write/read your data. To prepare for this possibility, don't forget to add appropriate flags like VK_BUFFER_USAGE_TRANSFER_DST_BIT, VK_BUFFER_USAGE_TRANSFER_SRC_BIT to the parameters of created buffer or image.
            HOST_ACCESS_ALLOW_TRANSFER_INSTEAD = 1 << 10,

            /// Allocation strategy that chooses smallest possible free range for the allocation to minimize memory usage and fragmentation, possibly at the expense of allocation time.
            STRATEGY_MIN_MEMORY = 1 << 11,

            /// Allocation strategy that chooses first suitable free range for the allocation - not necessarily in terms of the smallest offset but the one that is easiest and fastest to find to minimize allocation time, possibly at the expense of allocation quality.
            STRATEGY_MIN_TIME = 1 << 12,

            /// Allocation strategy that chooses always the lowest offset in available space. This is not the most efficient strategy but achieves highly packed data. Used internally by defragmentation, not recommended in typical usage.
            STRATEGY_MIN_OFFSET = 1 << 13,

            pub const STRATEGY_BEST_FIT = @This().STRATEGY_MIN_MEMORY;

            pub const STRATEGY_FIRST_FIT = @This().STRATEGY_MIN_TIME;

            const Flags = AllocationCreateFlags;
            pub const toFlags = vk.FlagBitsMixin(Flags, @This()).toFlags;
            pub const fromFlags = vk.FlagBitsMixin(Flags, @This()).fromFlags;
            pub const toInt = vk.FlagBitsMixin(Flags, @This()).toInt;
            pub const fromInt = vk.FlagBitsMixin(Flags, @This()).fromInt;
        };

        pub const AllocationCreateFlags = packed struct(u32) {
            /// Set this flag if the allocation should have its own memory block.
            ///
            /// Use it for special, big resources, like fullscreen images used as attachments.
            ///
            /// If you use this flag while creating a buffer or an image, VkMemoryDedicatedAllocateInfo structure is applied if possible.
            DEDICATED_MEMORY: bool = false,

            /// Set this flag to only try to allocate from existing VkDeviceMemory blocks and never create new such block.
            ///
            /// If new allocation cannot be placed in any of the existing blocks, allocation fails with VK_ERROR_OUT_OF_DEVICE_MEMORY error.
            ///
            /// You should not use VMA_ALLOCATION_CREATE_DEDICATED_MEMORY_BIT and VMA_ALLOCATION_CREATE_NEVER_ALLOCATE_BIT at the same time. It makes no sense.
            NEVER_ALLOCATE: bool = false,

            /// Set this flag to use a memory that will be persistently mapped and retrieve pointer to it.
            ///
            /// Pointer to mapped memory will be returned through VmaAllocationInfo::pMappedData.
            ///
            /// It is valid to use this flag for allocation made from memory type that is not HOST_VISIBLE. This flag is then ignored and memory is not mapped. This is useful if you need an allocation that is efficient to use on GPU (DEVICE_LOCAL) and still want to map it directly if possible on platforms that support it (e.g. Intel GPU).
            CREATE_MAPPED: bool = false,

            _reserved: vk.LockedInt(u1, 0) = .locked,

            /// Allocation will be created from upper stack in a double stack pool.
            ///
            /// This flag is only allowed for custom pools created with VMA_POOL_CREATE_LINEAR_ALGORITHM_BIT flag.
            UPPER_ADDRESS: bool = false,

            /// Create both buffer/image and allocation, but don't bind them together. It is useful when you want to bind yourself to do some more advanced binding, e.g. using some extensions. The flag is meaningful only with functions that bind by default: vmaCreateBuffer(), vmaCreateImage(). Otherwise it is ignored.
            ///
            /// If you want to make sure the new buffer/image is not tied to the new memory allocation through VkMemoryDedicatedAllocateInfoKHR structure in case the allocation ends up in its own memory block, use also flag VMA_ALLOCATION_CREATE_CAN_ALIAS_BIT.
            DONT_BIND: bool = false,

            /// Create allocation only if additional device memory required for it, if any, won't exceed memory budget. Otherwise return VK_ERROR_OUT_OF_DEVICE_MEMORY.
            WITHIN_BUDGET: bool = false,

            /// Set this flag if the allocated memory will have aliasing resources.
            ///
            /// Usage of this flag prevents supplying VkMemoryDedicatedAllocateInfoKHR when VMA_ALLOCATION_CREATE_DEDICATED_MEMORY_BIT is specified. Otherwise created dedicated memory will not be suitable for aliasing resources, resulting in Vulkan Validation Layer errors.
            CAN_ALIAS: bool = false,

            /// Requests possibility to map the allocation (using vmaMapMemory() or VMA_ALLOCATION_CREATE_MAPPED_BIT).
            ///
            /// If you use VMA_MEMORY_USAGE_AUTO or other VMA_MEMORY_USAGE_AUTO* value, you must use this flag to be able to map the allocation. Otherwise, mapping is incorrect.
            /// If you use other value of VmaMemoryUsage, this flag is ignored and mapping is always possible in memory types that are HOST_VISIBLE. This includes allocations created in Custom memory pools.
            /// Declares that mapped memory will only be written sequentially, e.g. using memcpy() or a loop writing number-by-number, never read or accessed randomly, so a memory type can be selected that is uncached and write-combined.
            ///
            /// Warning
            /// Violating this declaration may work correctly, but will likely be very slow. Watch out for implicit reads introduced by doing e.g. pMappedData[i] += x; Better prepare your data in a local variable and memcpy() it to the mapped pointer all at once.
            HOST_ACCESS_SEQUENTIAL_WRITE: bool = false,
            /// Requests possibility to map the allocation (using vmaMapMemory() or VMA_ALLOCATION_CREATE_MAPPED_BIT).
            ///
            /// If you use VMA_MEMORY_USAGE_AUTO or other VMA_MEMORY_USAGE_AUTO* value, you must use this flag to be able to map the allocation. Otherwise, mapping is incorrect.
            /// If you use other value of VmaMemoryUsage, this flag is ignored and mapping is always possible in memory types that are HOST_VISIBLE. This includes allocations created in Custom memory pools.
            /// Declares that mapped memory can be read, written, and accessed in random order, so a HOST_CACHED memory type is preferred.
            HOST_ACCESS_RANDOM: bool = false,

            /// Together with VMA_ALLOCATION_CREATE_HOST_ACCESS_SEQUENTIAL_WRITE_BIT or VMA_ALLOCATION_CREATE_HOST_ACCESS_RANDOM_BIT, it says that despite request for host access, a not-HOST_VISIBLE memory type can be selected if it may improve performance.
            ///
            /// By using this flag, you declare that you will check if the allocation ended up in a HOST_VISIBLE memory type (e.g. using vmaGetAllocationMemoryProperties()) and if not, you will create some "staging" buffer and issue an explicit transfer to write/read your data. To prepare for this possibility, don't forget to add appropriate flags like VK_BUFFER_USAGE_TRANSFER_DST_BIT, VK_BUFFER_USAGE_TRANSFER_SRC_BIT to the parameters of created buffer or image.
            HOST_ACCESS_ALLOW_TRANSFER_INSTEAD: bool = false,

            /// Allocation strategy that chooses smallest possible free range for the allocation to minimize memory usage and fragmentation, possibly at the expense of allocation time.
            STRATEGY_MIN_MEMORY: bool = false,

            /// Allocation strategy that chooses first suitable free range for the allocation - not necessarily in terms of the smallest offset but the one that is easiest and fastest to find to minimize allocation time, possibly at the expense of allocation quality.
            STRATEGY_MIN_TIME: bool = false,

            /// Allocation strategy that chooses always the lowest offset in available space. This is not the most efficient strategy but achieves highly packed data. Used internally by defragmentation, not recommended in typical usage.
            STRATEGY_MIN_OFFSET: bool = false,
            _reserved_trailing: vk.LockedInt(u18, 0) = .locked,

            const Bits = AllocationCreateFlagBits;
            pub const toInt = vk.FlagsMixin(@This(), Bits).toInt;
            pub const fromInt = vk.FlagsMixin(@This(), Bits).fromInt;
            pub const merge = vk.FlagsMixin(@This(), Bits).merge;
            pub const intersection = vk.FlagsMixin(@This(), Bits).intersection;
            pub const negation = vk.FlagsMixin(@This(), Bits).negation;
            pub const difference = vk.FlagsMixin(@This(), Bits).difference;
            pub const toBit = vk.FlagsMixin(@This(), Bits).toBit;
            pub const fromBit = vk.FlagsMixin(@This(), Bits).fromBit;
            pub const set = vk.FlagsMixin(@This(), Bits).set;
            pub const unset = vk.FlagsMixin(@This(), Bits).unset;
        };

        pub const PoolCreateFlagBits = enum(i32) {
            /// Use this flag if you always allocate only buffers and linear images or only optimal images out of this pool and so Buffer-Image Granularity can be ignored.
            ///
            /// This is an optional optimization flag.
            ///
            /// If you always allocate using vmaCreateBuffer(), vmaCreateImage(), vmaAllocateMemoryForBuffer(), then you don't need to use it because allocator knows exact type of your allocations so it can handle Buffer-Image Granularity in the optimal way.
            ///
            /// If you also allocate using vmaAllocateMemoryForImage() or vmaAllocateMemory(), exact type of such allocations is not known, so allocator must be conservative in handling Buffer-Image Granularity, which can lead to suboptimal allocation (wasted memory). In that case, if you can make sure you always allocate only buffers and linear images or only optimal images out of this pool, use this flag to make allocator disregard Buffer-Image Granularity and so make allocations faster and more optimal.
            IGNORE_BUFFER_IMAGE_GRANULARITY = 1 << 0,

            /// Enables alternative, linear allocation algorithm in this pool.
            ///
            /// Specify this flag to enable linear allocation algorithm, which always creates new allocations after last one and doesn't reuse space from allocations freed in between. It trades memory consumption for simplified algorithm and data structure, which has better performance and uses less memory for metadata.
            ///
            /// By using this flag, you can achieve behavior of free-at-once, stack, ring buffer, and double stack. For details, see documentation chapter Linear allocation algorithm.
            LINEAR_ALGORITHM = 1 << 1,

            const Flags = PoolCreateFlags;
            pub const toFlags = vk.FlagBitsMixin(Flags, @This()).toFlags;
            pub const fromFlags = vk.FlagBitsMixin(Flags, @This()).fromFlags;
            pub const toInt = vk.FlagBitsMixin(Flags, @This()).toInt;
            pub const fromInt = vk.FlagBitsMixin(Flags, @This()).fromInt;
        };
        pub const PoolCreateFlags = packed struct(u32) {
            /// Use this flag if you always allocate only buffers and linear images or only optimal images out of this pool and so Buffer-Image Granularity can be ignored.
            ///
            /// This is an optional optimization flag.
            ///
            /// If you always allocate using vmaCreateBuffer(), vmaCreateImage(), vmaAllocateMemoryForBuffer(), then you don't need to use it because allocator knows exact type of your allocations so it can handle Buffer-Image Granularity in the optimal way.
            ///
            /// If you also allocate using vmaAllocateMemoryForImage() or vmaAllocateMemory(), exact type of such allocations is not known, so allocator must be conservative in handling Buffer-Image Granularity, which can lead to suboptimal allocation (wasted memory). In that case, if you can make sure you always allocate only buffers and linear images or only optimal images out of this pool, use this flag to make allocator disregard Buffer-Image Granularity and so make allocations faster and more optimal.
            IGNORE_BUFFER_IMAGE_GRANULARITY: bool = false,

            /// Enables alternative, linear allocation algorithm in this pool.
            ///
            /// Specify this flag to enable linear allocation algorithm, which always creates new allocations after last one and doesn't reuse space from allocations freed in between. It trades memory consumption for simplified algorithm and data structure, which has better performance and uses less memory for metadata.
            ///
            /// By using this flag, you can achieve behavior of free-at-once, stack, ring buffer, and double stack. For details, see documentation chapter Linear allocation algorithm.
            LINEAR_ALGORITHM: bool = false,
            _reserved_trailing: vk.LockedInt(u30, 0) = .locked,

            const Bits = PoolCreateFlagBits;
            pub const toInt = vk.FlagsMixin(@This(), Bits).toInt;
            pub const fromInt = vk.FlagsMixin(@This(), Bits).fromInt;
            pub const merge = vk.FlagsMixin(@This(), Bits).merge;
            pub const intersection = vk.FlagsMixin(@This(), Bits).intersection;
            pub const negation = vk.FlagsMixin(@This(), Bits).negation;
            pub const difference = vk.FlagsMixin(@This(), Bits).difference;
            pub const toBit = vk.FlagsMixin(@This(), Bits).toBit;
            pub const fromBit = vk.FlagsMixin(@This(), Bits).fromBit;
            pub const set = vk.FlagsMixin(@This(), Bits).set;
            pub const unset = vk.FlagsMixin(@This(), Bits).unset;
        };
        pub const DefragmentationFlagBits = enum(i32) {
            FLAG_ALGORITHM_FAST = 1 << 0,
            FLAG_ALGORITHM_BALANCED = 1 << 1,
            FLAG_ALGORITHM_FULL = 1 << 2,
            /// Use the most roboust algorithm at the cost of time to compute and number of copies to make. Only available when bufferImageGranularity is greater than 1, since it aims to reduce alignment issues between different types of resources. Otherwise falls back to same behavior as VMA_DEFRAGMENTATION_FLAG_ALGORITHM_FULL_BIT.
            FLAG_ALGORITHM_EXTENSIVE = 1 << 3,
            const Flags = DefragmentationFlags;
            pub const toFlags = vk.FlagBitsMixin(Flags, @This()).toFlags;
            pub const fromFlags = vk.FlagBitsMixin(Flags, @This()).fromFlags;
            pub const toInt = vk.FlagBitsMixin(Flags, @This()).toInt;
            pub const fromInt = vk.FlagBitsMixin(Flags, @This()).fromInt;
        };
        pub const DefragmentationFlags = packed struct(u32) {
            FLAG_ALGORITHM_FAST: bool = false,
            FLAG_ALGORITHM_BALANCED: bool = false,
            FLAG_ALGORITHM_FULL: bool = false,
            /// Use the most roboust algorithm at the cost of time to compute and number of copies to make. Only available when bufferImageGranularity is greater than 1, since it aims to reduce alignment issues between different types of resources. Otherwise falls back to same behavior as VMA_DEFRAGMENTATION_FLAG_ALGORITHM_FULL_BIT.
            FLAG_ALGORITHM_EXTENSIVE: bool = false,
            _reserved_trailing: vk.LockedInt(u28, 0) = .locked,
            const Bits = DefragmentationFlagBits;
            pub const toInt = vk.FlagsMixin(@This(), Bits).toInt;
            pub const fromInt = vk.FlagsMixin(@This(), Bits).fromInt;
            pub const merge = vk.FlagsMixin(@This(), Bits).merge;
            pub const intersection = vk.FlagsMixin(@This(), Bits).intersection;
            pub const negation = vk.FlagsMixin(@This(), Bits).negation;
            pub const difference = vk.FlagsMixin(@This(), Bits).difference;
            pub const toBit = vk.FlagsMixin(@This(), Bits).toBit;
            pub const fromBit = vk.FlagsMixin(@This(), Bits).fromBit;
            pub const set = vk.FlagsMixin(@This(), Bits).set;
            pub const unset = vk.FlagsMixin(@This(), Bits).unset;
        };
        pub const DefragmentationMoveOperation = enum(c_int) {
            /// Buffer/image has been recreated at dstTmpAllocation, data has been copied, old buffer/image has been destroyed. srcAllocation should be changed to point to the new place. This is the default value set by vmaBeginDefragmentationPass().
            COPY,

            /// Set this value if you cannot move the allocation. New place reserved at dstTmpAllocation will be freed. srcAllocation will remain unchanged.
            IGNORE,

            /// Set this value if you decide to abandon the allocation and you destroyed the buffer/image. New place reserved at dstTmpAllocation will be freed, along with srcAllocation, which will be destroyed.
            DESTROY,
        };
        pub const VirtualBlockCreateFlagBits = enum(i32) {
            /// Enables alternative, linear allocation algorithm in this virtual block.
            ///
            /// Specify this flag to enable linear allocation algorithm, which always creates new allocations after last one and doesn't reuse space from allocations freed in between. It trades memory consumption for simplified algorithm and data structure, which has better performance and uses less memory for metadata.
            ///
            /// By using this flag, you can achieve behavior of free-at-once, stack, ring buffer, and double stack. For details, see documentation chapter Linear allocation algorithm.
            LINEAR_ALGORITHM = 1 << 0,

            const Flags = VirtualBlockCreateFlags;
            pub const toFlags = vk.FlagBitsMixin(Flags, @This()).toFlags;
            pub const fromFlags = vk.FlagBitsMixin(Flags, @This()).fromFlags;
            pub const toInt = vk.FlagBitsMixin(Flags, @This()).toInt;
            pub const fromInt = vk.FlagBitsMixin(Flags, @This()).fromInt;
        };
        pub const VirtualBlockCreateFlags = packed struct(u32) {
            /// Enables alternative, linear allocation algorithm in this virtual block.
            ///
            /// Specify this flag to enable linear allocation algorithm, which always creates new allocations after last one and doesn't reuse space from allocations freed in between. It trades memory consumption for simplified algorithm and data structure, which has better performance and uses less memory for metadata.
            ///
            /// By using this flag, you can achieve behavior of free-at-once, stack, ring buffer, and double stack. For details, see documentation chapter Linear allocation algorithm.
            LINEAR_ALGORITHM: bool = false,
            _reserved_trailing: vk.LockedInt(u31, 0) = .locked,
            const Bits = VirtualBlockCreateFlagBits;
            pub const toInt = vk.FlagsMixin(@This(), Bits).toInt;
            pub const fromInt = vk.FlagsMixin(@This(), Bits).fromInt;
            pub const merge = vk.FlagsMixin(@This(), Bits).merge;
            pub const intersection = vk.FlagsMixin(@This(), Bits).intersection;
            pub const negation = vk.FlagsMixin(@This(), Bits).negation;
            pub const difference = vk.FlagsMixin(@This(), Bits).difference;
            pub const toBit = vk.FlagsMixin(@This(), Bits).toBit;
            pub const fromBit = vk.FlagsMixin(@This(), Bits).fromBit;
            pub const set = vk.FlagsMixin(@This(), Bits).set;
            pub const unset = vk.FlagsMixin(@This(), Bits).unset;
        };
        pub const VirtualAllocationCreateFlagBits = enum(i32) {
            /// Allocation will be created from upper stack in a double stack pool.
            ///
            /// This flag is only allowed for virtual blocks created with VMA_VIRTUAL_BLOCK_CREATE_LINEAR_ALGORITHM_BIT flag.
            UPPER_ADDRESS = 1 << 0,

            /// Allocation strategy that tries to minimize memory usage.
            STRATEGY_MIN_MEMORY = 1 << 1,

            /// Allocation strategy that tries to minimize allocation time.
            STRATEGY_MIN_TIME = 1 << 2,

            /// Allocation strategy that chooses always the lowest offset in available space. This is not the most efficient strategy but achieves highly packed data.
            STRATEGY_MIN_OFFSET = 1 << 3,
            const Flags = VirtualAllocationCreateFlags;
            pub const toFlags = vk.FlagBitsMixin(Flags, @This()).toFlags;
            pub const fromFlags = vk.FlagBitsMixin(Flags, @This()).fromFlags;
            pub const toInt = vk.FlagBitsMixin(Flags, @This()).toInt;
            pub const fromInt = vk.FlagBitsMixin(Flags, @This()).fromInt;
        };
        pub const VirtualAllocationCreateFlags = packed struct(u32) {
            /// Allocation will be created from upper stack in a double stack pool.
            ///
            /// This flag is only allowed for virtual blocks created with VMA_VIRTUAL_BLOCK_CREATE_LINEAR_ALGORITHM_BIT flag.
            UPPER_ADDRESS: bool = false,

            /// Allocation strategy that tries to minimize memory usage.
            STRATEGY_MIN_MEMORY: bool = false,

            /// Allocation strategy that tries to minimize allocation time.
            STRATEGY_MIN_TIME: bool = false,

            /// Allocation strategy that chooses always the lowest offset in available space. This is not the most efficient strategy but achieves highly packed data.
            STRATEGY_MIN_OFFSET: bool = false,
            _reserved_trailing: vk.LockedInt(u28, 0) = .locked,
            const Bits = VirtualAllocationCreateFlagBits;
            pub const toInt = vk.FlagsMixin(@This(), Bits).toInt;
            pub const fromInt = vk.FlagsMixin(@This(), Bits).fromInt;
            pub const merge = vk.FlagsMixin(@This(), Bits).merge;
            pub const intersection = vk.FlagsMixin(@This(), Bits).intersection;
            pub const negation = vk.FlagsMixin(@This(), Bits).negation;
            pub const difference = vk.FlagsMixin(@This(), Bits).difference;
            pub const toBit = vk.FlagsMixin(@This(), Bits).toBit;
            pub const fromBit = vk.FlagsMixin(@This(), Bits).fromBit;
            pub const set = vk.FlagsMixin(@This(), Bits).set;
            pub const unset = vk.FlagsMixin(@This(), Bits).unset;
        };
        pub const PfnAllocateDeviceMemoryFunction = ?*const fn (allocator: Allocator, memoryType: u32, memory: vk.DeviceMemory, size: vk.DeviceSize, pUserData: ?*anyopaque) callconv(vk.vulkan_api) void;
        pub const PfnFreeDeviceMemoryFunction = ?*const fn (allocator: Allocator, memoryType: u32, memory: vk.DeviceMemory, size: vk.DeviceSize, pUserdata: ?*anyopaque) callconv(vk.vulkan_api) void;
        pub const PfnCheckDefragmentationBreakFunction = ?*const fn (pUserdata: ?*anyopaque) callconv(vk.vulkan_api) vk.Bool32;

        pub const ImportVulkanFunctionsFromVolkResult = enum(@typeInfo(vk.Result).@"enum".tag_type) {
            SUCCESS = @intFromEnum(vk.Result.SUCCESS),
        };

        extern fn vmaImportVulkanFunctionsFromVolk(pAllocatorCreateInfo: *const AllocatorCreateInfo, pDstVulkanFunctions: *VulkanFunctions) callconv(vk.vulkan_api) ImportVulkanFunctionsFromVolkResult;

        /// Fully initializes pDstVulkanFunctions structure with Vulkan functions needed by VMA using volk library.
        pub fn importVulkanFunctionsFromVolk(pAllocatorCreateInfo: *const AllocatorCreateInfo) VulkanFunctions {
            var result: VulkanFunctions = undefined;
            std.debug.assert(vmaImportVulkanFunctionsFromVolk(pAllocatorCreateInfo, &result) == .SUCCESS);
            return result;
        }

        pub const CreateAllocatorResult = enum(@typeInfo(vk.Result).@"enum".tag_type) {
            SUCCESS = @intFromEnum(vk.Result.SUCCESS),
        };
        extern fn vmaCreateAllocator(pCreateInfo: *const AllocatorCreateInfo, pAllocator: *Allocator) callconv(vk.vulkan_api) CreateAllocatorResult;

        /// Creates VmaAllocator object.
        pub fn createAllocator(pCreateInfo: *const AllocatorCreateInfo) Allocator {
            var result: Allocator = undefined;
            std.debug.assert(vmaCreateAllocator(pCreateInfo, &result) == .SUCCESS);
            return result;
        }
        extern fn vmaDestroyAllocator(allocator: Allocator) callconv(vk.vulkan_api) void;
        /// Destroys allocator object.
        pub fn destroyAllocator(allocator: Allocator) void {
            vmaDestroyAllocator(allocator);
        }

        extern fn vmaGetAllocatorInfo(allocator: Allocator, pAllocatorInfo: *AllocatorInfo) callconv(vk.vulkan_api) void;
        /// Returns information about existing VmaAllocator object - handle to Vulkan device etc.
        pub fn getAllocatorInfo(allocator: Allocator) AllocatorInfo {
            var result: AllocatorInfo = undefined;
            getAllocatorInfo(allocator, &result);
            return result;
        }
        extern fn vmaGetPhysicalDeviceProperties(allocator: Allocator, ppPhysicalDeviceProperties: **const vk.PhysicalDeviceProperties) callconv(vk.vulkan_api) void;
        pub fn getPhysicalDeviceProperties(allocator: Allocator) *const vk.PhysicalDeviceProperties {
            var result: *const vk.PhysicalDeviceProperties = undefined;
            vmaGetPhysicalDeviceProperties(allocator, &result);
            return result;
        }
        extern fn vmaGetMemoryProperties(allocator: Allocator, ppPhysicalDeviceMemoryProperties: **const vk.PhysicalDeviceMemoryProperties) callconv(vk.vulkan_api) void;
        pub fn getMemoryProperties(allocator: Allocator) *const vk.PhysicalDeviceMemoryProperties {
            var result: *const vk.PhysicalDeviceMemoryProperties = undefined;
            vmaGetMemoryProperties(allocator, &result);
            return result;
        }
        extern fn vmaGetMemoryTypeProperties(allocator: Allocator, memoryTypeIndex: u32, pFlags: *vk.MemoryPropertyFlags) callconv(vk.vulkan_api) void;
        /// Given Memory Type Index, returns Property Flags of this memory type.
        pub fn getMemoryTypeProperties(allocator: Allocator, memoryTypeIndex: u32) vk.MemoryPropertyFlags {
            var result: vk.MemoryPropertyFlags = undefined;
            vmaGetMemoryTypeProperties(allocator, memoryTypeIndex, &result);
            return result;
        }
        extern fn vmaSetCurrentFrameIndex(allocator: Allocator, frameIndex: u32) callconv(vk.vulkan_api) void;
        /// Sets index of the current frame.
        pub fn setCurrentFrameIndex(allocator: Allocator, frameIndex: u32) void {
            vmaSetCurrentFrameIndex(allocator, frameIndex);
        }

        extern fn vmaCalculateStatistics(allocator: Allocator, pStats: *TotalStatistics) callconv(vk.vulkan_api) void;
        /// Retrieves statistics from current state of the Allocator.
        pub fn calculateStatistics(allocator: Allocator) TotalStatistics {
            var result: TotalStatistics = undefined;
            vmaCalculateStatistics(allocator, &result);
            return result;
        }
        extern fn vmaGetHeapBudgets(allocator: Allocator, pBudgets: *Budget) callconv(vk.vulkan_api) void;
        /// Retrieves information about current memory usage and budget for all memory heaps.
        pub fn getHeapBudgets(allocator: Allocator) Budget {
            var result: Budget = undefined;
            vmaGetHeapBudgets(allocator, &result);
            return result;
        }
        pub const FindMemoryTypeIndexResult = enum(@typeInfo(vk.Result).@"enum".tag_type) {
            SUCCESS = @intFromEnum(vk.Result.SUCCESS),
            ERROR_FEATURE_NOT_PRESENT = @intFromEnum(vk.Result.ERROR_FEATURE_NOT_PRESENT),
        };
        extern fn vmaFindMemoryTypeIndex(allocator: Allocator, memoryTypeBits: std.bit_set.Integer(32), pAllocationCreateInfo: *const AllocationCreateInfo, pMemoryTypeIndex: *u32) callconv(vk.vulkan_api) FindMemoryTypeIndexResult;
        /// Helps to find memoryTypeIndex, given memoryTypeBits and VmaAllocationCreateInfo.
        pub const FindMemoryTypeIndexError = error{
            FEATURE_NOT_PRESENT,
        };
        pub fn findMemoryTypeIndex(
            allocator: Allocator,
            memoryTypeBits: std.bit_set.Integer(32),
            pAllocationCreateInfo: *const AllocationCreateInfo,
        ) FindMemoryTypeIndexError!u32 {
            var result: u32 = undefined;
            switch (vmaFindMemoryTypeIndex(allocator, memoryTypeBits, pAllocationCreateInfo, &result)) {
                .SUCCESS => {},
                .ERROR_FEATURE_NOT_PRESENT => return error.FEATURE_NOT_PRESENT,
            }
            return result;
        }
        extern fn vmaFindMemoryTypeIndexForBufferInfo(allocator: Allocator, pBufferCreateInfo: *const vk.BufferCreateInfo, pAllocationCreateInfo: *const AllocationCreateInfo, pMemoryTypeIndex: *u32) callconv(vk.vulkan_api) FindMemoryTypeIndexResult;
        /// Helps to find memoryTypeIndex, given VkBufferCreateInfo and VmaAllocationCreateInfo.
        pub fn findMemoryTypeIndexForBufferInfo(allocator: Allocator, pBufferCreateInfo: *const vk.BufferCreateInfo, pAllocationCreateInfo: *const AllocationCreateInfo) FindMemoryTypeIndexError!u32 {
            var result: u32 = undefined;
            switch (vmaFindMemoryTypeIndexForBufferInfo(allocator, pBufferCreateInfo, pAllocationCreateInfo, &result)) {
                .SUCCESS => {},
                .ERROR_FEATURE_NOT_PRESENT => return error.FEATURE_NOT_PRESENT,
            }
            return result;
        }
        extern fn vmaFindMemoryTypeIndexForImageInfo(allocator: Allocator, pImageCreateInfo: *const vk.ImageCreateInfo, pAllocationCreateInfo: *const AllocationCreateInfo, pMemoryTypeIndex: *u32) callconv(vk.vulkan_api) FindMemoryTypeIndexResult;
        /// Helps to find memoryTypeIndex, given VkImageCreateInfo and VmaAllocationCreateInfo.
        pub fn findMemoryTypeIndexForImageInfo(allocator: Allocator, pImageCreateInfo: *const vk.ImageCreateInfo, pAllocationCreateInfo: *const AllocationCreateInfo) FindMemoryTypeIndexError!u32 {
            var result: u32 = undefined;
            switch (vmaFindMemoryTypeIndexForImageInfo(allocator, pImageCreateInfo, pAllocationCreateInfo, &result)) {
                .SUCCESS => {},
                .ERROR_FEATURE_NOT_PRESENT => return error.FEATURE_NOT_PRESENT,
            }
            return result;
        }

        pub const CreatePoolResult = enum(@typeInfo(vk.Result).@"enum".tag_type) {
            SUCCESS = @intFromEnum(vk.Result.SUCCESS),
            ERROR_FEATURE_NOT_PRESENT = @intFromEnum(vk.Result.ERROR_FEATURE_NOT_PRESENT),
            ERROR_INITIALIZATION_FAILED = @intFromEnum(vk.Result.ERROR_INITIALIZATION_FAILED),
            ERROR_OUT_OF_DEVICE_MEMORY = @intFromEnum(vk.Result.ERROR_OUT_OF_DEVICE_MEMORY),
            ERROR_TOO_MANY_OBJECTS = @intFromEnum(vk.Result.ERROR_TOO_MANY_OBJECTS),
        };
        extern fn vmaCreatePool(allocator: Allocator, pCreateInfo: *const PoolCreateInfo, pPool: *Pool) callconv(vk.vulkan_api) CreatePoolResult;
        pub const CreatePoolError = error{
            FEATURE_NOT_PRESENT,
            INITIALIZATION_FAILED,
            OUT_OF_DEVICE_MEMORY,
            TOO_MANY_OBJECTS,
        };
        /// Allocates Vulkan device memory and creates VmaPool object.
        pub fn createPool(allocator: Allocator, pCreateInfo: *const PoolCreateInfo) CreatePoolError!Pool {
            var result: Pool = undefined;
            switch (vmaCreatePool(allocator, pCreateInfo, &result)) {
                .SUCCESS => {},
                .ERROR_FEATURE_NOT_PRESENT => return error.FEATURE_NOT_PRESENT,
                .ERROR_INITIALIZATION_FAILED => return error.INITIALIZATION_FAILED,
                .ERROR_OUT_OF_DEVICE_MEMORY => return error.OUT_OF_DEVICE_MEMORY,
                .ERROR_TOO_MANY_OBJECTS => return error.TOO_MANY_OBJECTS,
            }
            return result;
        }
        extern fn vmaDestroyPool(allocator: Allocator, pool: Pool) callconv(vk.vulkan_api) void;
        /// Destroys VmaPool object and frees Vulkan device memory.
        pub fn destroyPool(allocator: Allocator, pool: Pool) void {
            vmaDestroyPool(allocator, pool);
        }
        extern fn vmaGetPoolStatistics(allocator: Allocator, pool: Pool, pPoolStats: *Statistics) callconv(vk.vulkan_api) void;
        /// Retrieves statistics of existing VmaPool object.
        pub fn getPoolStatistics(allocator: Allocator, pool: Pool) Statistics {
            var result: Statistics = undefined;
            vmaGetPoolStatistics(allocator, pool, &result);
            return result;
        }
        extern fn vmaCalculatePoolStatistics(allocator: Allocator, pool: Pool, pPoolStats: *DetailedStatistics) callconv(vk.vulkan_api) void;
        /// Retrieves detailed statistics of existing VmaPool object.
        pub fn calculatePoolStatistics(allocator: Allocator, pool: Pool) DetailedStatistics {
            var result: DetailedStatistics = undefined;
            vmaCalculatePoolStatistics(allocator, pool, &result);
            return result;
        }
        pub const CheckPoolCorruptionResult = enum(@typeInfo(vk.Result).@"enum".tag_type) {
            SUCCESS = @intFromEnum(vk.Result.SUCCESS),
            ERROR_FEATURE_NOT_PRESENT = @intFromEnum(vk.Result.ERROR_FEATURE_NOT_PRESENT),
        };
        extern fn vmaCheckPoolCorruption(allocator: Allocator, pool: Pool) callconv(vk.vulkan_api) CheckPoolCorruptionResult;
        pub const CheckPoolCorruptionError = error{
            FEATURE_NOT_PRESENT,
        };
        /// Checks magic number in margins around all allocations in given memory pool in search for corruptions.
        pub fn checkPoolCorruption(allocator: Allocator, pool: Pool) CheckPoolCorruptionError!void {
            switch (vmaCheckPoolCorruption(allocator, pool)) {
                .SUCCESS => {},
                .ERROR_FEATURE_NOT_PRESENT => return error.FEATURE_NOT_PRESENT,
            }
        }
        extern fn vmaGetPoolName(allocator: Allocator, pool: Pool, ppName: *[*:0]const u8) callconv(vk.vulkan_api) void;
        /// Retrieves name of a custom pool.
        pub fn getPoolName(allocator: Allocator, pool: Pool) [*:0]const u8 {
            var result: [*:0]const u8 = undefined;
            vmaGetPoolName(allocator, pool, &result);
            return result;
        }
        extern fn vmaSetPoolName(allocator: Allocator, pool: Pool, pName: [*:0]const u8) callconv(vk.vulkan_api) void;
        /// Sets name of a custom pool.
        pub fn setPoolName(allocator: Allocator, pool: Pool, pName: [*:0]const u8) void {
            vmaSetPoolName(allocator, pool, pName);
        }
        pub const AllocateMemoryResult = enum(@typeInfo(vk.Result).@"enum".tag_type) {
            SUCCESS = @intFromEnum(vk.Result.SUCCESS),
            ERROR_INITIALIZATION_FAILED = @intFromEnum(vk.Result.ERROR_INITIALIZATION_FAILED),
            ERROR_FEATURE_NOT_PRESENT = @intFromEnum(vk.Result.ERROR_FEATURE_NOT_PRESENT),
            ERROR_OUT_OF_DEVICE_MEMORY = @intFromEnum(vk.Result.ERROR_OUT_OF_DEVICE_MEMORY),
            ERROR_TOO_MANY_OBJECTS = @intFromEnum(vk.Result.ERROR_TOO_MANY_OBJECTS),
        };
        extern fn vmaAllocateMemory(allocator: Allocator, pVkMemoryRequirements: *const vk.MemoryRequirements, pCreateInfo: *const AllocationCreateInfo, pAllocation: *Allocation, pAllocationInfo: ?*AllocationInfo) callconv(vk.vulkan_api) AllocateMemoryResult;
        pub const AllocateMemoryError = error{ INITIALIZATION_FAILED, FEATURE_NOT_PRESENT, OUT_OF_DEVICE_MEMORY, TOO_MANY_OBJECTS };
        /// General purpose memory allocation.
        pub fn allocateMemory(allocator: Allocator, pVkMemoryRequirements: *const vk.MemoryRequirements, pCreateInfo: *const AllocationCreateInfo, pAllocationInfo: ?*AllocationInfo) AllocateMemoryError!Allocation {
            var result: Allocation = undefined;
            switch (vmaAllocateMemory(allocator, pVkMemoryRequirements, pCreateInfo, &result, pAllocationInfo)) {
                .SUCCESS => {},
                .ERROR_INITIALIZATION_FAILED => return error.INITIALIZATION_FAILED,
                .ERROR_FEATURE_NOT_PRESENT => return error.FEATURE_NOT_PRESENT,
                .ERROR_OUT_OF_DEVICE_MEMORY => return error.OUT_OF_DEVICE_MEMORY,
                .ERROR_TOO_MANY_OBJECTS => return error.TOO_MANY_OBJECTS,
            }
            return result;
        }
        extern fn vmaAllocateDedicatedMemory(
            allocator: Allocator,
            pVkMemoryRequirements: *const vk.MemoryRequirements,
            pCreateInfo: *const AllocationCreateInfo,
            pMemoryAllocateNext: ?*anyopaque,
            pAllocation: *Allocator,
            pAllocationInfo: *AllocationInfo,
        ) callconv(vk.vulkan_api) AllocateMemoryResult;
        /// General purpose allocation of a dedicated memory.
        extern fn vmaAllocateMemoryPages(allocator: Allocator, pVkMemoryRequirements: *const vk.MemoryRequirements, pCreateInfo: *const AllocationCreateInfo, allocationCount: usize, pAllocations: *Allocation, pAllocationInfo: ?*AllocationInfo) callconv(vk.vulkan_api) AllocateMemoryResult;
        /// General purpose memory allocation for multiple allocation objects at once.
        extern fn vmaAllocateMemoryForBuffer(allocator: Allocator, buffer: vk.Buffer, pCreateInfo: *const AllocationCreateInfo, pAllocation: *Allocator, pAllocationInfo: ?*AllocationInfo) callconv(vk.vulkan_api) AllocateMemoryResult;
        /// Allocates memory suitable for given VkBuffer.
        extern fn vmaAllocateMemoryForImage(allocator: Allocator, image: vk.Image, pCreateInfo: *const AllocationCreateInfo, pAllocation: *Allocation, pAllocationInfo: ?*AllocationInfo) callconv(vk.vulkan_api) AllocateMemoryResult;
        /// Allocates memory suitable for given VkImage.
        extern fn vmaFreeMemory(allocator: Allocator, allocation: Allocation) callconv(vk.vulkan_api) void;
        /// Frees memory previously allocated using vmaAllocateMemory(), vmaAllocateMemoryForBuffer(), or vmaAllocateMemoryForImage().
        extern fn vmaFreeMemoryPages(allocator: Allocator, allocationCount: usize, pAllocations: [*]const Allocation) callconv(vk.vulkan_api) void;
        /// Frees memory and destroys multiple allocations.
        extern fn vmaGetAllocationInfo(allocator: Allocator, allocation: Allocation, pAllocationInfo: *AllocationInfo) callconv(vk.vulkan_api) void;
        /// Returns current information about specified allocation.
        extern fn vmaGetAllocationInfo2(allocator: Allocator, allocation: Allocation, pAllocationInfo: *AllocationInfo2) callconv(vk.vulkan_api) void;
        /// Returns extended information about specified allocation.
        extern fn vmaSetAllocationUserData(allocator: Allocator, allocation: Allocation, pUserData: ?*anyopaque) callconv(vk.vulkan_api) void;
        /// Sets pUserData in given allocation to new value.
        extern fn vmaSetAllocationName(allocator: Allocator, allocation: Allocation, pName: [*:0]const u8) callconv(vk.vulkan_api) void;
        /// Sets pName in given allocation to new value.
        extern fn vmaGetAllocationMemoryProperties(allocator: Allocator, allocation: Allocation, pFlags: *vk.MemoryPropertyFlags) callconv(vk.vulkan_api) void;
        /// Given an allocation, returns Property Flags of its memory type.
        extern fn vmaGetMemoryWin32Handle(allocator: Allocator, allocation: Allocation, hTargetProcess: vk.HANDLE, pHandle: *vk.HANDLE) callconv(vk.vulkan_api) VkResult;
        /// Given an allocation, returns Win32 handle that may be imported by other processes or APIs.
        extern fn vmaGetMemoryWin32Handle2(allocator: Allocator, allocation: Allocation, handleType: vk.ExternalMemoryHandleTypeFlagBits, hTargetProcess: vk.HANDLE, pHandle: *vk.HANDLE) callconv(vk.vulkan_api) VkResult;
        /// Given an allocation, returns Win32 handle that may be imported by other processes or APIs.
        extern fn vmaMapMemory(allocator: Allocator, allocation: Allocation, ppData: **anyopaque) callconv(vk.vulkan_api) VkResult;
        /// Maps memory represented by given allocation and returns pointer to it.
        extern fn vmaUnmapMemory(allocator: Allocator, allocation: Allocation) callconv(vk.vulkan_api) void;
        /// Unmaps memory represented by given allocation, mapped previously using vmaMapMemory().
        extern fn vmaFlushAllocation(allocator: Allocator, allocation: Allocation, offset: vk.DeviceSize, size: vk.DeviceSize) callconv(vk.vulkan_api) VkResult;
        /// Flushes memory of given allocation.
        extern fn vmaInvalidateAllocation(allocator: Allocator, allocation: Allocation, offset: vk.DeviceSize, size: vk.DeviceSize) callconv(vk.vulkan_api) VkResult;
        /// Invalidates memory of given allocation.
        extern fn vmaFlushAllocations(allocator: Allocator, allocationCount: u32, allocations: [*]const Allocation, offsets: [*]const vk.DeviceSize, sizes: [*]const vk.DeviceSize) callconv(vk.vulkan_api) VkResult;
        /// Flushes memory of given set of allocations.
        extern fn vmaInvalidateAllocations(allocator: Allocator, allocationCount: u32, allocations: [*]const Allocation, offsets: [*]const vk.DeviceSize, sizes: [*]const vk.DeviceSize) callconv(vk.vulkan_api) VkResult;
        /// Invalidates memory of given set of allocations.
        extern fn vmaCopyMemoryToAllocation(allocator: Allocator, pSrcHostPointer: *const anyopaque, dstAllocation: Allocation, dstAllocationLocalOffset: vk.DeviceSize, size: vk.DeviceSize) callconv(vk.vulkan_api) VkResult;
        /// Maps the allocation temporarily if needed, copies data from specified host pointer to it, and flushes the memory from the host caches if needed.
        extern fn vmaCopyAllocationToMemory(allocator: Allocator, srcAllocation: Allocation, srcAllocationLocalOffset: vk.DeviceSize, pDstHostPointer: *anyopaque, size: vk.DeviceSize) callconv(vk.vulkan_api) VkResult;
        /// Invalidates memory in the host caches if needed, maps the allocation temporarily if needed, and copies data from it to a specified host pointer.
        extern fn vmaCheckCorruption(allocator: Allocator, memoryTypeBits: std.bit_set.Integer(32)) callconv(vk.vulkan_api) VkResult;
        /// Checks magic number in margins around all allocations in given memory types (in both default and custom pools) in search for corruptions.
        extern fn vmaBeginDefragmentation(allocator: Allocator, pInfo: *const DefragmentationInfo, pContext: *DefragmentationContext) callconv(vk.vulkan_api) VkResult;
        /// Begins defragmentation process.
        extern fn vmaEndDefragmentation(allocator: Allocator, context: DefragmentationContext, pStats: *DefragmentationStats) callconv(vk.vulkan_api) void;
        /// Ends defragmentation process.
        extern fn vmaBeginDefragmentationPass(allocator: Allocator, context: DefragmentationContext, pPassInfo: *DefragmentationPassMoveInfo) callconv(vk.vulkan_api) VkResult;
        /// Starts single defragmentation pass.
        extern fn vmaEndDefragmentationPass(allocator: Allocator, context: DefragmentationContext, pPassInfo: *DefragmentationPassMoveInfo) callconv(vk.vulkan_api) VkResult;
        /// Ends single defragmentation pass.
        extern fn vmaBindBufferMemory(allocator: Allocator, allocation: Allocation, buffer: vk.Buffer) callconv(vk.vulkan_api) VkResult;
        /// Binds buffer to allocation.
        extern fn vmaBindBufferMemory2(allocator: Allocator, allocation: Allocation, allocationLocalOffset: vk.DeviceSize, buffer: vk.Buffer, pNext: ?*const anyopaque) callconv(vk.vulkan_api) VkResult;
        /// Binds buffer to allocation with additional parameters.
        extern fn vmaBindImageMemory(allocator: Allocator, allocation: Allocation, image: vk.Image) callconv(vk.vulkan_api) VkResult;
        /// Binds image to allocation.
        extern fn vmaBindImageMemory2(allocator: Allocator, allocation: Allocation, allocationLocalOffset: vk.DeviceSize, image: vk.Image, pNext: ?*const anyopaque) callconv(vk.vulkan_api) VkResult;
        /// Binds image to allocation with additional parameters.
        extern fn vmaCreateBuffer(allocator: Allocator, pBufferCreateInfo: *const VkBufferCreateInfo, pAllocationCreateInfo: *const AllocationCreateInfo, pBuffer: *vk.Buffer, pAllocation: *Allocation, pAllocationInfo: ?*AllocationInfo) callconv(vk.vulkan_api) VkResult;
        /// Creates a new VkBuffer, allocates and binds memory for it.
        extern fn vmaCreateBufferWithAlignment(allocator: Allocator, pBufferCreateInfo: *const vk.BufferCreateInfo, pAllocationCreateInfo: *const AllocationCreateInfo, minAlignment: vk.DeviceSize, pBuffer: *vk.Buffer, pAllocation: *Allocation, pAllocationInfo: ?*AllocationInfo) callconv(vk.vulkan_api) VkResult;
        /// Creates a buffer with additional minimum alignment.
        extern fn vmaCreateDedicatedBuffer(allocator: Allocator, pBufferCreateInfo: *const vk.BufferCreateInfo, pAllocationCreateInfo: *const AllocationCreateInfo, pMemoryAllocateNext: ?*anyopaque, pBuffer: *vk.Buffer, pAllocation: *Allocation, pAllocationInfo: ?*AllocationInfo) callconv(vk.vulkan_api) VkResult;
        /// Creates a dedicated buffer while offering extra parameter pMemoryAllocateNext.
        extern fn vmaCreateAliasingBuffer(allocator: Allocator, allocation: Allocation, pBufferCreateInfo: *const vk.BufferCreateInfo, pBuffer: *vk.Buffer) callconv(vk.vulkan_api) VkResult;
        /// Creates a new VkBuffer, binds already created memory for it.
        extern fn vmaCreateAliasingBuffer2(allocator: Allocator, allocation: Allocation, allocationLocalOffset: vk.DeviceSize, pBufferCreateInfo: *const vk.BufferCreateInfo, pBuffer: *vk.Buffer) callconv(vk.vulkan_api) VkResult;
        /// Creates a new VkBuffer, binds already created memory for it.
        extern fn vmaDestroyBuffer(allocator: Allocator, buffer: vk.Buffer, allocation: Allocation) callconv(vk.vulkan_api) void;
        /// Destroys Vulkan buffer and frees allocated memory.
        extern fn vmaCreateImage(allocator: Allocator, pImageCreateInfo: *const vk.ImageCreateInfo, pAllocationCreateInfo: *const AllocationCreateInfo, pImage: *vk.Image, pAllocation: *Allocation, pAllocationInfo: ?*AllocationInfo) callconv(vk.vulkan_api) VkResult;
        /// Function similar to vmaCreateBuffer() but for images.
        extern fn vmaCreateDedicatedImage(allocator: Allocator, pImageCreateInfo: *const vk.ImageCreateInfo, pAllocationCreateInfo: *const AllocationCreateInfo, pMemoryAllocateNext: ?*anyopaque, pImage: *vk.Image, pAllocation: *Allocation, pAllocationInfo: ?*AllocationInfo) callconv(vk.vulkan_api) VkResult;
        /// Function similar to vmaCreateDedicatedBuffer() but for images.
        extern fn vmaCreateAliasingImage(allocator: Allocator, allocation: Allocation, pImageCreateInfo: *const vk.ImageCreateInfo, pImage: *vk.Image) callconv(vk.vulkan_api) VkResult;
        /// Function similar to vmaCreateAliasingBuffer() but for images.
        extern fn vmaCreateAliasingImage2(allocator: Allocator, allocation: Allocation, allocationLocalOffset: vk.DeviceSize, pImageCreateInfo: *const vk.ImageCreateInfo, pImage: *vk.Image) callconv(vk.vulkan_api) VkResult;
        /// Function similar to vmaCreateAliasingBuffer2() but for images.
        extern fn vmaDestroyImage(allocator: Allocator, image: vk.Image, allocation: Allocation) callconv(vk.vulkan_api) void;
        /// Destroys Vulkan image and frees allocated memory.
        extern fn vmaCreateVirtualBlock(pCreateInfo: *const VirtualBlockCreateInfo, pVirtualBlock: *VirtualBlock) callconv(vk.vulkan_api) VkResult;
        /// Creates new VmaVirtualBlock object.
        extern fn vmaDestroyVirtualBlock(virtualBlock: VirtualBlock) callconv(vk.vulkan_api) void;
        /// Destroys VmaVirtualBlock object.
        extern fn vmaIsVirtualBlockEmpty(virtualBlock: VirtualBlock) callconv(vk.vulkan_api) vk.Bool32;
        /// Returns true of the VmaVirtualBlock is empty - contains 0 virtual allocations and has all its space available for new allocations.
        extern fn vmaGetVirtualAllocationInfo(virtualBlock: VirtualBlock, allocation: VirtualAllocation, pVirtualAllocInfo: *VirtualAllocationInfo) callconv(vk.vulkan_api) void;
        /// Returns information about a specific virtual allocation within a virtual block, like its size and pUserData pointer.
        extern fn vmaVirtualAllocate(virtualBlock: VirtualBlock, pCreateInfo: *const VirtualAllocationCreateInfo, pAllocation: *VirtualAllocation, pOffset: *vk.DeviceSize) callconv(vk.vulkan_api) VkResult;
        /// Allocates new virtual allocation inside given VmaVirtualBlock.
        extern fn vmaVirtualFree(virtualBlock: VirtualBlock, allocation: VirtualAllocation) callconv(vk.vulkan_api) void;
        /// Frees virtual allocation inside given VmaVirtualBlock.
        extern fn vmaClearVirtualBlock(virtualBlock: VirtualBlock) callconv(vk.vulkan_api) void;
        /// Frees all virtual allocations inside given VmaVirtualBlock.
        extern fn vmaSetVirtualAllocationUserData(virtualBlock: VirtualBlock, allocation: VirtualAllocation, pUserData: ?*anyopaque) callconv(vk.vulkan_api) void;
        /// Changes custom pointer associated with given virtual allocation.
        extern fn vmaGetVirtualBlockStatistics(virtualBlock: VirtualBlock, pStats: *Statistics) callconv(vk.vulkan_api) void;
        /// Calculates and returns statistics about virtual allocations and memory usage in given VmaVirtualBlock.
        extern fn vmaCalculateVirtualBlockStatistics(virtualBlock: VirtualBlock, pStats: *DetailedStatistics) callconv(vk.vulkan_api) void;
        /// Calculates and returns detailed statistics about virtual allocations and memory usage in given VmaVirtualBlock.
        extern fn vmaBuildVirtualBlockStatsString(virtualBlock: VirtualBlock, ppStatsString: *[*:0]u8, detailedMap: vk.Bool32) callconv(vk.vulkan_api) void;
        /// Builds and returns a null-terminated string in JSON format with information about given VmaVirtualBlock.
        extern fn vmaFreeVirtualBlockStatsString(virtualBlock: VirtualBlock, pStatsString: [*:0]u8) callconv(vk.vulkan_api) void;
        /// Frees a string returned by vmaBuildVirtualBlockStatsString().
        extern fn vmaBuildStatsString(allocator: Allocator, ppStatsString: *[*:0]u8, detailedMap: vk.Bool32) callconv(vk.vulkan_api) void;
        /// Builds and returns statistics as a null-terminated string in JSON format.
        extern fn vmaFreeStatsString(allocator: Allocator, pStatsString: [*:0]u8) callconv(vk.vulkan_api) void;
    };
}
