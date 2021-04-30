# frozen_string_literal: true

class DiscountCode < ApplicationRecord
    belongs_to :restaurant, class_name: 'Restaurant'
    has_many :receipts

    def self.types; ["PercentageOffBasketDiscountCode"]; end
    def self.code_matches(code); where('lower(code) = ?', code.downcase); end
    def self.is_active; where("expires_on >= ? OR expires_on IS NULL", 1.days.ago); end

    before_save :downcase_code
    
    scope :is_active?, -> { is_active }
    scope :code_matches?, ->(code) { code_matches(code) }
    
    validates_presence_of :type, :code, :amount
    validates :code, format: { with: /\A[a-zA-Z0-9]+\Z/ }

    validate :discount_code, if: :code_changed?
    validates :code, length: { minimum: 3, maximum: 10 }
    validates :type, inclusion: { in: DiscountCode.types }

    def expiry_date; self.expires_on.present? ? self.expires_on.strftime("%Y-%m-%d") : "Never"; end

    def is_active?
      self.expires_on.nil? || self.expires_on >= 1.days.ago
    end

    private

    def downcase_code; self.code.downcase; end

    def discount_code
      if DiscountCode.code_matches(self.code).is_active.present?
        errors.add(:code, 'is not unique or is already active')
      end
    end
  
  
  end
